local intro = {}

local player = require "game.player"
local options = require "game.options"
local ram = require "game.ram"
local dialog = require "game.dialog"

local function skipCutscene()
	-- Skip the intro cutscene
	while ram.menuSelection() == 0 do
		player.press("Start")
	end
end

local function openOptionsMenu()
	while ram.menuCursorBuffer() ~= 2 do
		player.press("Down")
	end

	while ram.inMenu() == 0 do
		player.press("A")
	end
end

local function setOption(index, mask, expected)
	-- Select the right index.
	while index ~= ram.optionsIndex() do
		player.press("Down")
	end

	-- Hit left until it's correct.
	while bit.band(mask, ram.options()) ~= expected do
		player.press("Left")
	end
end

local function setOptions()
	-- TODO Generalize this some more.
	-- textSpeed = 0x06, battleScene = 0x80, battleStyle = 0x40
	setOption(0, 0x6, 0x1) -- textSpeed = "fast"
	setOption(1, 0x80, 0x80) -- battleSceen = "off"
	setOption(2, 0x40, 0x40) -- battleStyle = "set"

	-- menuAccount is special.
	index = 5

	-- Select the right index.
	while index ~= ram.optionsIndex() do
		player.press("Down")
	end

	-- Hit left until it's correct.
	while ram.optionsMenuAccount() == 0 do
		player.press("Left")
	end
end

local function closeOptionsMenu()
	while ram.inMenu() == 1 do
		player.press("B")
	end
end

local function startGame()
	while ram.menuCursorBuffer() == 1 do
		player.press("A")
	end
end

local function chooseGender()
	while ram.menuCursorY() == 0 do
		player.wait()
	end

	while ram.textDelayFrames() == 0 do
		player.press("A")
	end
end

local function setHour(hour)
	while ram.initHourBuffer() == 0 do
		player.wait()
	end

	while ram.initHourBuffer() > hour do
		player.press("Down")
	end

	while ram.initHourBuffer() < hour do
		player.press("Up")
	end

	while ram.stringBuffer2Char2() ~= hour do
		player.press("A")
	end
end

local function setMinute(minute)
	while minute ~= ram.initMinuteBuffer() do
		if minute > 30 then
			player.press("Down")
		else
			player.press("Up")
		end
	end

	while minute ~= ram.stringBuffer2Char3() do
		player.press("A")
	end
end

local function yikes()
	while ram.tileDialogAdvance() ~= 127 do
		player.press("A")
	end
end

local function chooseName()
	while ram.textDelayFrames() ~= 0 do
		player.wait()
	end

	while ram.textDelayFrames() == 0 do
		player.wait()
	end

	while ram.textDelayFrames() ~= 0 do
		player.press("A")
	end

	while ram.farCallBCBuffer() ~= 195 do
		player.wait()
	end

	while ram.farCallBCBuffer() == 195 do
		player.press("A")
	end

	while ram.farCallBCBuffer() == 0 do
		player.press("Start")
	end

	while ram.farCallBCBuffer() == 195 do
		player.press("A")
	end
end

function intro.run()
	skipCutscene()

	openOptionsMenu()
	setOptions()
	closeOptionsMenu()

	startGame()
	chooseGender()

	dialog.advance(3)

	setHour(17)
	dialog.selectYes()
	setMinute(50)
	dialog.selectYes()

	dialog.advance(1)
	yikes()

	dialog.advance(17)

	chooseName()
	dialog.advance(7)
end

return intro
