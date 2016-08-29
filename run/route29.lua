local route29 = {}

local player = require "game.player"
local battle = require "game.battle"
local wram = require "game.wram"

local function onBattle()
	-- Totodile level
	if wram.byte(0x0639) > 5 then
		battle.run()
		return
	end

	-- Enemy level
	if wram.byte(0x1213) < 3 then
		battle.run()
		return
	end

	battle.fight()
end

function route29.run()
	player.moveTo(59, 8) -- starting position
	player.navigate(0, 7, onBattle)
	player.move("Left")
end

function route29.run2() 
	player.moveTo(0, 7) -- starting position
	player.navigate(59, 8)
	player.move("Right")
end

return route29
