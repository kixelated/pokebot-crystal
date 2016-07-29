local newbark = {}

local ram = require "game.ram"
local input = require "game.input"
local dialog = require "game.dialog"
local menu = require "game.menu"

--[[
local directionMap = {
	Down = 0,
	Up = 4,
	Left = 8,
	Right = 12,
}

local function face(direction)
	local value = directionMap[direction]
	if value ~= ram.byte(0xd4de) then
		input.press(direction)
	end
end

local function move(direction, times)
	face(direction)

	for i=1,times do
		input.press(direction)
	end
end

local function moveTo(x, y)
	local currX = ram.byte(0xdcb8)
	local currY = ram.byte(0xdcb7)

	console.log("moving from", currX, currY)
	console.log("moving to", x, y)

	local diffX = x - currX
	if diffX > 0 then
		move("Right", diffX)
	elseif diffX < 0 then
		move("Left", -diffX)
	end

	local diffY = y - currY
	if diffY > 0 then
		move("Up", diffY)
	elseif diffY < 0 then
		move("Down", -diffY)
	end
end
--]]

local function moveTo(x, y)
	while true do
		local pos = ram.byte(0xdcb8)
		if pos == x then
			break
		elseif pos > x then
			input.raw("Left")
		else
			input.raw("Right")
		end
	end

	while true do
		local pos = ram.byte(0xdcb7)
		if pos == y then
			break
		elseif pos > y then
			input.raw("Up")
		else
			input.raw("Down")
		end
	end
end

local function move(direction)
	local addr
	if direction == "Down" or direction == "Up" then
		addr = 0xdcb7
	else
		addr = 0xdcb8
	end

	local curr = ram.byte(addr)
	while ram.byte(addr) == curr do
		input.raw(direction)
	end
end

local function face(direction)
	while ram.byte(0xd436) == 0 do -- hits 16 for one frame
		input.raw(direction)
	end
end

local function talkToMum()
	input.press("A")

	dialog.advance(12)

	-- TODO remove press special
	input.pressSpecial("A") -- select sunday

	menu.pick("YES") -- confirmation
	menu.pick("NO") -- daylight savings
	menu.pick("YES") -- confirmation

	dialog.advance(3)
	menu.pick("YES")

	dialog.advance(5)
end

local function pickPokemon()
	input.press("A")
	input.press("B")

	dialog.advance(1)
	menu.pick("YES")

	dialog.advance(4)
	menu.pick("NO")
end

function newbark.run()
	moveTo(3, 3)
	moveTo(7, 3)
	moveTo(7, 1)
	move("Up")

	-- Stairs
	moveTo(9, 1)
	moveTo(7, 1)
	moveTo(7, 3)

	talkToMum()

	moveTo(8, 3)
	moveTo(8, 7)
	moveTo(7, 7)
	move("Down")
	
	-- Door
	moveTo(13, 6)
	moveTo(6, 6)
	moveTo(6, 4)
	move("Up")

	dialog.advance(12)
	menu.pick("YES")

	dialog.advance(26)

	-- Automatically moved here.
	moveTo(4, 4)
	moveTo(7, 4)
	face("Up")

	pickPokemon()

	dialog.advance(11)

	-- Automatically moved here.
	moveTo(5, 3)
	moveTo(5, 8)

	dialog.advance(7)

	moveTo(5, 11)
	move("Down")

	moveTo(6, 4)
	moveTo(6, 7)
	moveTo(2, 7)
	moveTo(2, 8)
	moveTo(0, 8)
	move("Left")
end

return newbark
