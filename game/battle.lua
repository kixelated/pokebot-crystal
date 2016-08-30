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

	local onStartTurn = function()
		menu.pick(action)
		if action == "FIGHT" then
			input.press("A")
		end
	end

	local onDialog = function()
		input.press("A")
	end

	local eventBattleTurn = watch.onexecute(0x3c12f, onStartTurn)
	local eventButtonSound = watch.onexecute(0xaaf, onDialog)
	local eventJoyWait = watch.onexecute(0xa36, onDialog)
	local eventWaitPress = watch.onexecute(0xa80, onDialog)
	local eventSimpleWaitPress = watch.onexecute(0xaa5, onDialog)

	while battle.active() do
		input.wait()
	end	

	watch.remove(eventBattleTurn)
	watch.remove(eventButtonSound)
	watch.remove(eventJoyWait)
	watch.remove(eventWaitPress)
	watch.remove(eventSimpleWaitPress)
end

function battle.run()
	start("RUN")
end

function battle.fight()
	start("FIGHT")
end


return battle
