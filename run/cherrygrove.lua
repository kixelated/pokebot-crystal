local cherrygrove = {}

local player = require "game.player"
local battle = require "game.battle"
local dialog = require "game.dialog"
local input = require "game.input"

function cherrygrove.run()
	player.moveTo(39, 7) -- starting position
	player.moveTo(28, 7)
	player.moveTo(28, 4)
	player.moveTo(17, 4)
	player.moveTo(17, 0)
	player.move("Up")
end

function cherrygrove.run2()
	player.moveTo(17, 0) -- starting position
	player.moveTo(17, 4)
	player.moveTo(28, 4)
	player.moveTo(28, 7)
	player.moveTo(33, 7)

	dialog.advance(7)

	battle.fight()

	dialog.advance(5)

	player.moveTo(33, 8)
	player.moveTo(33, 7)
	player.moveTo(39, 7)
	player.move("Right")
end

return cherrygrove
