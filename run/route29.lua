local route29 = {}

local player = require "game.player"
local battle = require "game.battle"

local function onBattle()
	battle.start()
	battle.run()
	battle.finish()
end

function route29.run()
	player.moveTo(59, 8, onBattle) -- starting position
	player.moveTo(44, 8, onBattle)
	player.moveTo(44, 14, onBattle)
	player.moveTo(38, 14, onBattle)
	player.moveTo(38, 16, onBattle)
	player.moveTo(31, 16, onBattle)
	player.moveTo(31, 10, onBattle)
	player.moveTo(36, 10, onBattle)
	player.moveTo(36, 6, onBattle)
	player.moveTo(21, 6, onBattle)
	player.moveTo(21, 3, onBattle)
	player.moveTo(16, 3, onBattle)
	player.moveTo(16, 7, onBattle)
	player.moveTo(14, 7, onBattle)
	player.moveTo(14, 8, onBattle)
	player.moveTo(4, 8, onBattle)
	player.moveTo(4, 7, onBattle)
	player.moveTo(0, 7, onBattle)
	player.move("Left")
end

return route29
