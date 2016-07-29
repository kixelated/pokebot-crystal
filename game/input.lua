local input = {}

local ram = require "game.ram"

local buttonMask = {
	A      = 0,
	B      = 1,
	Select = 2,
	Start  = 3,
	Right  = 4,
	Left   = 5,
	Up     = 6,
	Down   = 7,
}

function input.raw(button)
	inputTable = {}
	if button ~= nil then
		inputTable[button] = true
	end

	joypad.set(inputTable)
	emu.frameadvance()
end

input.wait = input.raw

-- Press button for a frame when possible.
function input.press(button)
	console.log("press", button)

	-- The gameboy registers joypad input using a bitmask for each button:
	--   a=0 b=1 select=2 start=3 right=4 left=5 up=6 down=7
	--
	-- These masks are stored in three variables: 
	--   hJoypadDown: if the button is currently pressed.
	--   hJoypadPressed: if the button was not pressed last frame but is now.
	--   hJoypadReleased: if the button was pressed last frame but not now.
	--
	-- However, the pokemon game engine only occasionally checks the input.
	-- This means it will not register presses if it was doing something.
	--
	-- They get around this by using their own variables and occasionally
	-- updating them using the gameboy values:
	--   hJoyDown, hJoyPressed, hJoyReleased
	--
	-- There is also a 4th variable called hJoyLast that contains either
	-- hJoyDown or hJoyPressed depending on if it's a menu. This variable
	-- is not reset until the text is done being printed an a dialog can be
	-- advanced. We use this for the most part except for some one-offs.

	local mask = buttonMask[button]

	-- Wait for the button to stop being pressed.
	while bit.check(ram.joyDown(), mask) do
		input.wait()
	end

	-- Wait for the button to register as pressed.
	while not bit.check(ram.joyDown(), mask) do
		input.raw(button)
	end
end

-- TODO Remove.
function input.pressSpecial(button)
	-- Wait for the button to stop being pressed.
	while ram.joyLast() ~= 0 do
		input.wait()
	end

	input.press(button)
end

return input
