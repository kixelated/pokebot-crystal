local map = {}

local wram = require "game.wram"
local bus = require "game.bus"
local astar = require "lib.astar"

local WALK_COST = 20 -- frames
local BATTLE_COST = 900 -- frames

function map.tileCollision(x, y)
	local mapWidth = wram.byte(0x119f)
	local mapBlockDataBank = wram.byte(0x11a0)
	local mapBlockDataAddr = wram.word(0x11a1)

	local addr = mapBlockDataAddr + mapWidth * math.floor(y / 2) + math.floor(x / 2)
	local tile = bus.byte(addr, mapBlockDataBank)

	local tilesetCollisionBank = wram.byte(0x11df)
	local tilesetCollisionAddr = wram.word(0x11e0)

	local addr = tilesetCollisionAddr + 4 * tile + (x % 2) + (y % 2) * 2
	local collision = bus.byte(addr, tilesetCollisionBank)

	return collision
end

function map.tileValid(x, y)
	local mapWidth = wram.byte(0x119f)
	local mapHeight = wram.byte(0x119e)

	if x < 0 or x >= mapWidth * 2 then
		return false
	end

	if y < 0 or y >= mapHeight * 2 then
		return false
	end

	return true
end

local function navigateCompare(node1, node2)
	return node1.x == node2.x and node1.y == node2.y
end

local function navigateCost(node1, node2)
	local tiles = math.abs(node1.x - node2.x) + math.abs(node1.y - node2.y)
	local cost = tiles * WALK_COST

	-- There doesn't seem to be a turning penalty, but prefer walking straight anyway.
	if node1.dir ~= node2.dir then
		cost = cost + 1
	end

	local collision = map.tileCollision(node1.x, node1.y)
	if collision == 0x18 then
		-- TODO don't hard-code 10% chance for battle.
		cost = cost + BATTLE_COST * 0.1
	end

	return cost
end

local function navigateHeuristic(node, goal)
	local tiles = math.abs(node.x - goal.x) + math.abs(node.y - goal.y)
	local cost = tiles * WALK_COST

	return cost
end

local function navigateNextDir(node, direction)
	local distance = 1

	-- Get the collision of the current tile.
	local collision = map.tileCollision(node.x, node.y)

	-- jumpable tile
	local jumpable = (bit.band(collision, 0xa0) == 0xa0)
	if jumpable then
		-- If we can jump from this tile in the right direction, move 2 tiles instead.
		if collision == 0xa0 and direction == "Right" then
			distance = 2
		elseif collision == 0xa1 and direction == "Left" then
			distance = 2
		elseif collision == 0xa3 and direction == "Down" then
			distance = 2
		elseif collision == 0xa4 and (direction == "Right" or direction == "Down") then
			distance = 2
		elseif collision == 0xa5 and (direction == "Left" or direction == "Down") then
			distance = 2
		end
	end


	local newNode = {
		x = node.x,
		y = node.y,
		dir = direction,
	}

	if direction == "Right" then
		newNode.x = newNode.x + distance
	elseif direction == "Left" then
		newNode.x = newNode.x - distance
	elseif direction == "Down" then
		newNode.y = newNode.y + distance
	elseif direction == "Up" then
		newNode.y = newNode.y - distance
	end

	if not map.tileValid(newNode.x, newNode.y) then
		return nil
	end

	local newCollision = map.tileCollision(newNode.x, newNode.y)

	-- normal tile
	if newCollision == 0 then
		return newNode
	end

	-- tall grass
	if newCollision == 0x18 then
		return newNode
	end

	-- jumpable tile
	if bit.band(newCollision, 0xa0) == 0xa0 then
		return newNode
	end

	return nil
end

local function navigateNext(node)
	local newNodes = {}
	local directions = { "Right", "Left", "Up", "Down" }

	for i,direction in ipairs(directions) do
		local newNode = navigateNextDir(node, direction)
		if newNode ~= nil then
			table.insert(newNodes, newNode)
		end
	end

	return newNodes
end

function map.calculatePath(start, goal)
	local path = astar.find(start, goal, navigateCompare, navigateNext, navigateCost, navigateHeuristic)
	return path
end

return map
