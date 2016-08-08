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
	player.navigate(13, 9, onBattle)

	player.face("Right")
	player.interact()
	dialog.advance(2)

	player.navigate(17, 6, onBattle)
	player.move("Up")
	
	dialog.advance(49)

	player.moveTo(3, 6)
	player.moveTo(3, 7)
	player.move("Down")

	dialog.advance(4)

	player.moveTo(17, 6, onBattle)
	player.navigate(7, 53, onBattle)
	player.move("Down")
end

return route30
