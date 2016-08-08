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
	player.navigate(0, 7, onBattle)
	player.move("Left")
end

return route29
