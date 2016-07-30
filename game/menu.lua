local menu = {}

local input = require "game.input"
local ram = require "game.ram"
local strings = require "game.strings"

-- Waits for a menu to appear.
function menu.wait()
	while ram.joyLast() ~= 0 do
		input.wait()
	end
end

-- Returns the options if a menu has the items written inline (ex yes@no@)
function menu.optionsSimple()
	local menuBank = ram.byte(0xcf8a)
	local menuDataPointer = ram.word(0xcf86)
	local menuDataItems = ram.byte(0xcf92)

	local result = {}
	local pointer = menuDataPointer + 2

	for i=1, menuDataItems do
		local string, length = strings.parse(pointer, menuBank)
		result[i] = string

		pointer = pointer + length + 1
	end

	return result
end

-- Returns an array of available options in the current menu.
function menu.options()
	local menuBank = ram.byte(0xcf8a)
	local menuData2Pointer = ram.word(0xcf86)

	-- The same as wMenuData2Items for simple menus, otherwise zero.
	local menuData2Size = ram.byteBank(menuData2Pointer + 1, menuBank)
	if menuData2Size > 0 then
		return menu.optionsSimple()
	end

	local menuIndiciesPointer = ram.word(0xcf93)
	local menuDataItems = ram.byte(0xcf92)

	local indicies = {}
	for i=1,menuDataItems do
		indicies[i] = ram.byteBank(menuIndiciesPointer + i, menuBank)
	end

	-- Contains 3 pointers for each index: func, string, desc
	local menuTablePointer = ram.word(0xcf97)

	local result = {}
	for i,index in ipairs(indicies) do
		local itemTablePointer = menuTablePointer + (index * 6) + 2
		local stringPointer = ram.wordBank(itemTablePointer, menuBank)
		local string = strings.parse(stringPointer, menuBank)

		result[i] = string
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
