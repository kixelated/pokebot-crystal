local dialog = {}

local input = require "game.input"
local bus = require "game.bus"
local hram = require "game.hram"
local menu = require "game.menu"
local watch = require "game.watch"

-- This function waits until a known function that waits for joypad input is called.
function dialog.wait()
	local waiting = true
	local doneWaiting = function()
		waiting = false
	end

	-- All of these are found in home/joypad.asm
	local onButtonSound = watch.onexecute(0xaaf, doneWaiting)
	local onJoyWait = watch.onexecute(0xa36, doneWaiting)
	local onWaitPress = watch.onexecute(0xa80, doneWaiting)
	local onSimpleWaitPress = watch.onexecute(0xaa5, doneWaiting)

	while waiting do
		input.wait()
	end

	watch.remove(onButtonSound)
	watch.remove(onJoyWait)
	watch.remove(onWaitPress)
	watch.remove(onSimpleWaitPress)
end

function dialog.advance(times)
	times = times or 1
	for i=1,times do
		dialog.wait()
		input.press("A")
	end
end

return dialog
