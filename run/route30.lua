local route30 = {}

local player = require "game.player"
local battle = require "game.battle"
local dialog = require "game.dialog"
local input = require "game.input"

local function onBattle()
	battle.start()
	battle.run()
	battle.finish()
end

function route30.run()
	player.moveTo(7, 53) -- starting position
	player.moveTo(7, 48)
	player.moveTo(12, 48, onBattle)
	player.moveTo(12, 28, onBattle)
	player.moveTo(14, 28, onBattle)
	player.moveTo(14, 23, onBattle)
	player.moveTo(11, 23, onBattle)
	player.moveTo(11, 17, onBattle)
	player.moveTo(13, 17, onBattle)
	player.moveTo(13, 9, onBattle)

	player.face("Right")
	player.interact()
	dialog.advance(2)

	player.moveTo(17, 9, onBattle)
	player.moveTo(17, 6, onBattle)
	player.move("Up")
	
	dialog.advance(49)

	player.moveTo(3, 6)
	player.moveTo(3, 7)
	player.move("Down")

	dialog.advance(4)
	player.moveTo(17, 6, onBattle)
	player.moveTo(17, 11, onBattle)
	player.moveTo(11, 11, onBattle)
	player.moveTo(11, 17, onBattle)
	player.moveTo(11, 23, onBattle)
	player.moveTo(14, 23, onBattle)
	player.moveTo(14, 31, onBattle)
	player.moveTo(3, 31, onBattle)
	player.moveTo(3, 41, onBattle)
	player.moveTo(7, 41, onBattle)
	player.moveTo(7, 53, onBattle)
	player.move("Down")
end

return route30
