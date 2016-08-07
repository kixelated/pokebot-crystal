local dialog = {}

local input = require "game.input"
local bus = require "game.bus"
local hram = require "game.hram"
local menu = require "game.menu"

-- This function waits until a known function that waits for joypad input is called.
function dialog.wait()
	local waiting = true
	local doneWaiting = function() waiting = false end

	-- All of these are found in home/joypad.asm
	local onButtonSound = event.onmemoryexecute(doneWaiting, 0xaaf)
	local onJoyWait = event.onmemoryexecute(doneWaiting, 0xa36)
	local onWaitPress = event.onmemoryexecute(doneWaiting, 0xa80)
	local onSimpleWaitPress = event.onmemoryexecute(doneWaiting, 0xaa5)

	while waiting do
		input.wait()
	end

	event.unregisterbyid(onButtonSound)
	event.unregisterbyid(onJoyWait)
	event.unregisterbyid(onWaitPress)
	event.unregisterbyid(onSimpleWaitPress)
end

function dialog.advance(times)
	times = times or 1
	for i=1,times do
		dialog.wait()
		input.press("A")
	end
end

return dialog
