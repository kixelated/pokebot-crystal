local player = {}

function player.press(button)
	inputTable = {}

	if button then
		inputTable[button] = true
	end

	joypad.set(inputTable)
	emu.frameadvance()
end

function player.wait()
	player.press()
end

return player
