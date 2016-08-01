local menu = {}

local input = require "game.input"
local ram = require "game.ram"
local wram = require "game.wram"
local bus = require "game.bus"
local strings = require "game.strings"

-- Waits for a menu to appear.
function menu.wait()
	while ram.joyLast() ~= 0 do
		input.wait()
	end
end

-- Returns the options if a menu has the items written inline (ex yes@no@)
function menu.optionsSimple()
	local menuDataBank = wram.byte(0x0f8a)
	local menuDataPointer = wram.word(0x0f86)
	local menuDataItems = wram.byte(0x0f92)

	local result = {}
	local pointer = menuDataPointer + 2

	for i=1, menuDataItems do
		local string, length = strings.parse(pointer, menuDataBank)
		result[i] = {
			y = i,
			x = i,
			text = string,
		}

		pointer = pointer + length
	end

	return result
end

local function optionInlineString(index)
	local menuDataBank = wram.byte(0x0f8a)
	local menuData2PointerTableAddr = wram.word(0x0f97)

	local pointer = menuData2PointerTableAddr
	local string


	-- Keep parsing strings until we find the one we want.
	for i=0,index do
		string, size = strings.parse(pointer, menuDataBank)
		pointer = pointer + size
	end

	return string
end

local function optionStartMenu(index)
	local menuDataBank = wram.byte(0x0f8a)
	local menuData2PointerTableAddr = wram.word(0x0f97)

	-- Contains 3 pointers for each index: func, string, desc
	local stringPointerAddr = menuData2PointerTableAddr + (index * 6) + 2
	local stringPointer = ram.word(stringPointerAddr, menuDataBank)
	local string = strings.parse(stringPointer, menuDataBank)

	return string
end

function menu.options2D()
	local menuDataBank = wram.byte(0x0f8a)

	-- Otherwise, we need to follow the 1st pointer to a list of indicies.
	local menuData2Indicies = {}
	local menuData2IndiciesPointer = wram.word(0x0f93)
	local menuData2IndiciesSize = bus.byte(menuData2IndiciesPointer, menuDataBank)
	for i=1,menuData2IndiciesSize do
		menuData2Indicies[i] = bus.byte(menuData2IndiciesPointer + i, menuDataBank)
	end

	-- The 2nd pointer is the function called with the current index.
	-- Unfortunately, these functions are custom and expect the data to be of different sizes/formats.
	local menuData2DisplayFunction = wram.word(0x0f95)

	-- Get the read address of the display function.
	local map, realAddr = bus.map(menuData2DisplayFunction, menuDataBank)

	local optionFunction
	if realAddr == 0x1f79 then
		-- PlaceMenuStrings
		optionFunction = optionInlineString
	elseif realAddr == 0x127ef then
		-- StartMenu
		optionFunction = optionStartMenu
	else
		error("unknown display function "..bizstring.hex(realAddr))
	end

	local result = {}
	for i,index in ipairs(menuData2Indicies) do
		local text = optionFunction(index)

		result[i] = {
			y = i,
			x = 1,
			text = text
		}
	end

	return result
end

function menu.optionsScrolling()
	local menuDataBank = wram.byte(0x0f8a)
	local menuData2Pointer = wram.word(0x0f86)

	local menuNumRows = wram.byte(0x0fa3)
	local menuNumCols = wram.byte(0x0fa4)

	local stringPointerBank = bus.byte(menuData2Pointer + 3, menuDataBank)
	local stringPointerAddr = bus.word(menuData2Pointer + 4, menuDataBank)

	result = {}
	for y=1,menuNumRows do
		for x=1,menuNumCols do
			local string, size = strings.parse(stringPointerAddr, stringPointerBank)

			local i = menuNumCols * (y - 1) + x
			result[i] = {
				y = y,
				x = x,
				text = string,
			}

			stringPointerAddr = stringPointerAddr + size
		end
	end

	return result
end

-- Returns an array of available options in the current menu.
function menu.options()
	local menuDataBank = wram.byte(0x0f8a)
	local menuData2Pointer = wram.word(0x0f86)

	-- If the size is not defined, then it's a 2D menu with a lookup table.
	if bus.byte(menuData2Pointer + 1, menuDataBank) == 0 then
		return menu.options2D()
	end

	-- TODO This is a hack to detect scrolling menus.
	if bus.byte(menuData2Pointer + 2, menuDataBank) < 10 then
		return menu.optionsScrolling()
	end

	return menu.optionsSimple()
end

-- So I went overboard and made a function that will select a menu item given the text string.
-- No more memorizing indexes!
function menu.pick(text)
	menu.wait()

	local options = menu.options()

	local result
	for i, v in pairs(options) do
		if v.text == text then
			result = v
			break
		end
	end

	if result == nil then
		error("option "..text.." not found")
	end

	menu.pickIndex(result.y, result.x)
end

function menu.pickIndex(y, x)
	local cursorX = ram.menuCursorX()
	local cursorY = ram.menuCursorY()

	if y > cursorY then
		for i=cursorY, y-1 do
			input.press("Down")
		end
	else
		for i=cursorY, y+1, -1 do
			input.press("Up")
		end
	end

	if x > cursorX then
		for i=cursorX, x-1 do
			input.press("Right")
		end
	else 
		for i=cursorX, x+1, -1 do
			input.press("Left")
		end
	end

	input.press("A")
end

return menu
