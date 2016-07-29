local menu = {}

local input = require "game.input"
local ram = require "game.ram"

-- Copied from pokebot, not verified to be correct.
local CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ():;[]abcdefghijklmnopqrstuvwxyz?????????????????????????????????????????-???!.????????*?/.?0123456789"

-- Waits for a menu to appear.
function menu.wait()
	while ram.joyLast() ~= 0 do
		input.wait()
	end
end

-- Returns an array of available options in the current menu.
function menu.options()
	local result = {}

	local menuBank = ram.byte(0xcf8a)
	local menuDataPointer = ram.word(0xcf86)
	local menuDataFlags = ram.byte(0xcf91)
	local menuDataSize = ram.byte(0xcf92)

	local index = 1
	local string = ""
	local pointer = menuDataPointer + 2

	while index <= menuDataSize do
		local byte = ram.byteBank(pointer, menuBank)

		if byte == 0x50 then
			-- @ in the code, used as a delimiter
			result[index] = string

			string = ""
			index = index + 1
		else
			-- TODO error handling.
			local charIndex = byte - 0x80 + 1 -- +1 because lua is 1-indexed
			if charIndex > 0 and charIndex <= string.len(CHARS) then
				local char = string.sub(CHARS, charIndex, charIndex)
				string = string..char
			else
				error("invalid character: "..bizstring.hex(byte))
			end
		end

		pointer = pointer + 1
	end

	return result
end

-- So I went overboard and made a function that will select a menu item given the text string.
-- No more memorizing indexes!
function menu.pick(option)
	menu.wait()

	local options = menu.options()

	local index = 0
	for i, v in pairs(options) do
		if v == option then
			index = i
			break
		end
	end

	if index == 0 then
		console.log("target:", option)
		console.log("options:", options)
		error("option not found")
	end

	menu.pickIndex(index)
end

function menu.pickIndex(index)
	-- TODO Figure out if the menu wraps around and if that's faster.
	while index > ram.menuCursorY() do
		input.press("Down")
	end

	while index < ram.menuCursorY() do
		input.press("Up")
	end

	input.press("A")
end

return menu
