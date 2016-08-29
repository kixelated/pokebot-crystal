local battle = {}

local input = require "game.input"
local menu = require "game.menu"
local dialog = require "game.dialog"
local wram = require "game.wram"
local hram = require "game.hram"
local watch = require "game.watch"

function battle.active()
	return wram.byte(0x122d) ~= 0
end

local function start(action)
	while not battle.active() do
		input.wait()
	end

	startTurn = false
	pressA = false

	local onStartTurn = function()
		startTurn = true
	end

	local onDialog = function()
		pressA = true
	end

	local eventBattleTurn = watch.execute(onStartTurn, 0x3c12f)
	local eventButtonSound = watch.execute(onDialog, 0xaaf)
	local eventJoyWait = watch.execute(onDialog, 0xa36)
	local eventWaitPress = watch.execute(onDialog, 0xa80)
	local eventSimpleWaitPress = watch.execute(onDialog, 0xaa5)

	while battle.active() do
		if pressA then
			input.press("A")
			pressA = false
		elseif startTurn then
			menu.pick(action)
			if action == "FIGHT" then
				input.press("A")
			end

			startTurn = false
		else
			input.wait()
		end
	end	

	event.unregisterbyid(eventBattleTurn)
	event.unregisterbyid(eventButtonSound)
	event.unregisterbyid(eventJoyWait)
	event.unregisterbyid(eventWaitPress)
	event.unregisterbyid(eventSimpleWaitPress)
end

function battle.run()
	start("RUN")
end

function battle.fight()
	start("FIGHT")
end


return battle
