local player = {}

local wram = require "game.wram"
local input = require "game.input"
local map = require "game.map"

function player.facing() 
	local map = {
		Down = 0,
		Up = 4,
		Left = 8,
		Right = 12,

	}

	return map[wram.byte(0x14de)]
end

function player.navigate(x, y, onBattle)
	local currX = wram.byte(0x1cb8)
	local currY = wram.byte(0x1cb7)

	local path = map.calculatePath(currX, currY, x, y)
	if path == nil then
		error("path not found")
	end

	while true do
		local nextNode = table.remove(path)
		if nextNode == nil then
			break
		end

		player.moveTo(nextNode.x, nextNode.y, onBattle)
	end
end

function player.moveTo(x, y, onBattle)
	while true do
		local battleType = wram.byte(0x122d)
		if battleType ~= 0 then
			onBattle()
		end
		
		if wram.byte(0x1cb8) > x then
			input.raw("Left")
		elseif wram.byte(0x1cb8) < x then
			input.raw("Right")
		elseif wram.byte(0x1cb7) > y then
			input.raw("Up")
		elseif wram.byte(0x1cb7) < y then
			input.raw("Down")
		else
			break
		end
	end
end

function player.move(direction)
	local addr
	if direction == "Down" or direction == "Up" then
		addr = 0x1cb7
	else
		addr = 0x1cb8
	end

	local curr = wram.byte(addr)
	while wram.byte(addr) == curr do
		input.raw(direction)
	end
end

function player.face(direction)
	local current = player.facing()
	if current == direction then
		return
	end

	-- Wait until we stop moving first.
	while wram.byte(0x1044) ~= 0 do
		input.wait()
	end

	input.press(direction)
end

function player.interact()
	-- Wait until we stop moving first.
	while wram.byte(0x1044) ~= 0 do
		input.wait()
	end

	input.press("A")
end

function player.wait()
	input.wait()
end

return player
