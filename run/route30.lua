local route30 = {}

local player = require "game.player"
local battle = require "game.battle"
local dialog = require "game.dialog"
local input = require "game.input"
local wram = require "game.wram"

local function onBattle()
	-- Totodile level
	if wram.byte(0x1cfe) > 5 then
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
