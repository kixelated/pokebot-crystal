local intro = {}

local input = require "game.input"
local options = require "game.options"
local ram = require "game.ram"
local dialog = require "game.dialog"
local menu = require "game.menu"

local function skipCutscene()
	input.press("Start")
	input.press("Start")
end

local function setOptions()
	input.press("Down")
	input.press("A")

	input.press("Left") -- textSpeed = "high"
	input.press("Down")
	input.press("Left") -- battleScene = "off"
	input.press("Down")
	input.press("Left") -- battleStyle = "set"

	input.press("Down")
	input.press("Down")
	input.press("Down")
	input.press("Left") -- menuAccount = "on"

	input.press("B")
end

local function startGame()
	input.press("A")
end

local function setHour(hour)
	while ram.initHourBuffer() == 0 do
		input.wait()
	end

	while ram.initHourBuffer() > hour do
		input.pressSpecial("Down")
	end

	while ram.initHourBuffer() < hour do
		input.pressSpecial("Up")
	end

	input.pressSpecial("A")

	menu.pick("YES") -- confirmation
end

local function setMinute(minute)
	while minute ~= ram.initMinuteBuffer() do
		if minute > 30 then
			input.pressSpecial("Down")
		else
			input.pressSpecial("Up")
		end
	end

	input.pressSpecial("A")

	menu.pick("YES") -- confirmation
end


local function chooseName()
	input.press("A")

	input.press("A")
	input.press("Start")
	input.press("A")
end

function intro.run()
	skipCutscene()
	setOptions()
	startGame()

	menu.pick("Boy")
	dialog.advance(3)

	setHour(17)
	setMinute(50)

	dialog.advance(19)

	chooseName()

	dialog.advance(7)

	while ram.byte(0xdcb6) == 0 do -- map number
		input.wait()
	end
end

return intro
