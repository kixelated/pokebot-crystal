local dialog = {}

local input = require "game.input"
local bus = require "game.bus"
local hram = require "game.hram"
local menu = require "game.menu"

function dialog.wait()
	local debug = false
	if debug then
		console.clear()
	end

	-- This function is stupid complicated but it's the best way I've found to advance dialog.
	-- For each frame, we check the current position of the Program Counter register in the GameBoy.
	-- This signals which line of code will run when the gameboy resumes operation. The idea is that
	-- we can look at this line to figure out what the GameBoy is currently doing.
	--
	-- In normal operation, the program counter updates many many times a second. Sometimes we need to
	-- use a range because we're not sure which operation could be running. We also don't know what
	-- type of data is on the stack in this case. Luckily, the GameBoy has a command that sleeps until
	-- the next frame to save battery. Pokemon calls helper methods called DelayFrame or DelayFrames.
	--
	-- Since these functions do not use the stack, we can look at the first two bytes at the stack
	-- pointer to figure out which method called them. We go up the stack a few times until we have the
	-- program counter that will be executed after the delay finishes. If this matches our small list
	-- of functions that block on pressing A, we can just press A!
	--
	--
	-- This solution is definitely more complicated than I would like but there is otherwise no way
	-- to tell when JoyWaitAorB is called. This is the 5th iteration of dialog.advance()

	while true do
		local pc = emu.getregister("PC")
		local sp = emu.getregister("SP")

		local romBank = hram.byte(0x9d)
		_, pc = bus.map(pc, romBank)

		while true do
			if pc >= 0x45a and pc < 0x468 then
				-- DelayFrame
				-- This is called by functions to sleep a frame.
				-- The off by one is caused when interrupts are enabled/disabled.
				-- Sleeps for multiple frames, calls DelayFrame each time.
			elseif pc >= 0x468 and pc < 0x46f then
				-- DelayFrames
				-- Sleeps for multiple frames, calls DelayFrame each time.
			elseif pc == 0x48 or pc == 0x552 then
				-- LCD interrupt
				-- Fires randomly, mostly after DelayFrame.
			elseif pc >= 0x553 and pc < 0x559 then
				sp = sp + 2
			elseif pc >= 0x559 and pc < 0x556 then
				sp = sp + 4
			elseif pc == 0x566 then
				-- another LCD interrupt, this time pop the stack
				sp = sp + 2
			elseif pc >= 0xa57 and pc < 0xa80 then
				-- JoyTextDelay
			else
				-- Stop unrolling the stack.
				break
			end

			-- Grab the next item on the stack to see the caller function.
			pc = bus.word(sp)
			sp = sp + 2
		end

		if pc >= 0xaaf and pc < 0xaef then
			-- ButtonSound
			if debug then
				console.log("ButtonSound")
			end

			return
		elseif pc >= 0xac6 and pc < 0xaf5 then
			-- .wait_input
			-- Called by ButtonSound
			if debug then
				console.log(".wait_input")
			end

			return
		elseif pc >= 0xa46 and pc < 0xa57 then
			-- WaitButton
			if debug then
				console.log("WaitButton")
			end

			return
		elseif pc >= 0xa36 and pc < 0xa46 then 
			-- JoyWaitAorB
			if debug then
				console.log("JoyWaitAorB")
			end

			return
		elseif pc >= 0xa80 and pc < 0xaa5 then
			-- WaitPressAorB_BlinkCursor
			-- This is a busy loop so we need a range of possible locations.
			if debug then
				console.log("WaitPressAorB_BlinkCursor")
			end

			return
		elseif debug then
			console.log("unknown "..bizstring.hex(pc).." "..bizstring.hex(bus.word(sp)))
		end

		input.wait()
	end
end

function dialog.advance(times)
	times = times or 1
	for i=1,times do
		dialog.wait()
		input.press("A")
	end
end

return dialog
