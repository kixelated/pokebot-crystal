local newbark = {}

local player = require "game.player"
local dialog = require "game.dialog"

local function moveTo(x, y)
	local currX = mainmemory.readbyte(0x1cb8)
	local currY = mainmemory.readbyte(0x1cb7)

	while x < mainmemory.readbyte(0x1cb8) do
		player.press("Left")
	end

	while x > mainmemory.readbyte(0x1cb8) do
		player.press("Right")
	end
	
	while y > mainmemory.readbyte(0x1cb7) do
		player.press("Down")
	end

	while y < mainmemory.readbyte(0x1cb7) do
		player.press("Up")
	end
end

local function move(direction)
	local addr
	if direction == "Down" or direction == "Up" then
		addr = 0x1cb7
	else
		addr = 0x1b8
	end

	local curr = mainmemory.readbyte(addr)
	while mainmemory.readbyte(addr) == curr do
		player.press(direction)
	end
end

local function face(direction)
	while mainmemory.readbyte(0x1436) == 0 do -- hits 16 for one frame
		player.press(direction)
	end
end

local function selectYes()
	while mainmemory.readbyte(0x0fcf) ~= 3 do
		player.wait()
	end

	while mainmemory.readbyte(0x0fcf) ~= 1 do
		player.wait()
	end

	while mainmemory.readbyte(0x0fcf) == 1 do
		player.press("A")
	end
end

local function talkToMum()
	while mainmemory.readbyte(0x0fcf) ~= 3 do
		player.press("A")
	end

	dialog.advance(12)

	selectYes()
	selectYes()
	selectYes()
	selectYes()

	dialog.advance(3)

	selectYes()

	dialog.advance(4)
	dialog.advanceSpecial()
end

local function pickPokemon()
	while mainmemory.readbyte(0x103e) == 0 do -- wtf
		player.press("A")
	end

	while mainmemory.readbyte(0x150b) ~= 0 do -- wtf
		player.press("B")
	end

	dialog.advance(1)
	selectYes()

	dialog.advance(4)
	selectYes()
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

	selectYes()

	dialog.advance(5)
	dialog.advanceSpecial()

	dialog.advance(2)
	dialog.advanceSpecial()

	dialog.advance(11)
	dialog.advanceSpecial()

	dialog.advance(4)
	dialog.advanceSpecial()

	-- Autoscroller
	moveTo(4, 4)
	moveTo(7, 4)
	face("Up")

	pickPokemon()
end

return newbark
