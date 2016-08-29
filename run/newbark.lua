local newbark = {}

local input = require "game.input"
local dialog = require "game.dialog"
local menu = require "game.menu"
local player = require "game.player"

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
	player.interact()
	input.press("B")

	dialog.advance(1)
	menu.pick("YES")

	dialog.advance(4)
	menu.pick("NO")
end

function newbark.run()
	player.moveTo(3, 3)
	player.moveTo(7, 3)
	player.moveTo(7, 1)
	player.move("Up")

	-- Stairs
	player.moveTo(9, 1)
	player.moveTo(7, 1)
	player.moveTo(7, 3)

	talkToMum()

	player.moveTo(8, 3)
	player.moveTo(8, 7)
	player.moveTo(7, 7)
	player.move("Down")
	
	-- Door
	player.moveTo(13, 6)
	player.moveTo(6, 6)
	player.moveTo(6, 4)
	player.move("Up")

	dialog.advance(12)
	menu.pick("YES")

	dialog.advance(26)

	-- Automatically moved here.
	player.moveTo(4, 4)
	player.moveTo(7, 4)
	player.face("Up")

	pickPokemon()

	dialog.advance(11)

	-- Automatically moved here.
	player.moveTo(5, 3)
	player.moveTo(5, 8)

	dialog.advance(7)

	player.moveTo(5, 11)
	player.move("Down")

	player.moveTo(6, 4)
	player.moveTo(6, 7)
	player.moveTo(2, 7)
	player.moveTo(2, 8)
	player.moveTo(0, 8)
	player.move("Left")
end

function newbark.run2()
	player.moveTo(0, 8) -- starting position
	player.moveTo(2, 8)
	player.moveTo(2, 7)
	player.moveTo(6, 7)
	player.moveTo(6, 4)
	player.move("Up")

	player.moveTo(4, 3)
	dialog.advance(8)

	input.press("Right")
	input.press("A")
	input.press("Start")
	input.press("A")

	dialog.advance(2)

	player.moveTo(5, 3)
	player.face("Up")
	player.interact()

	dialog.advance(27)

	player.moveTo(5, 8)
	dialog.advance(8)

	player.moveTo(5, 11)
	player.move("Down")

	player.moveTo(6, 4)
	player.moveTo(6, 7)
	player.moveTo(2, 7)
	player.moveTo(2, 8)
	player.moveTo(0, 8)
	player.move("Left")
end

return newbark
