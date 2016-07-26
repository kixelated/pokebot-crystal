local options = {}

local ram = require "game.ram"

function options.textSpeed()
	local value = ram.read("options", "textSpeed")

	if value == 0 then
		return "fast"
	elseif value == 2 then
		return "mid"
	elseif value == 4 then
		return "slow"
	end
end

function options.battleScene()
	local value = ram.read("options", "battleScene")
	if value == 0 then
		return "on"
	else
		return "off"
	end
end

function options.battleStyle()
	local value = ram.read("options", "battleStyle")
	if value == 0 then
		return "shift"
	else
		return "set"
	end
end

function options.menuAccount()
	local value = ram.read("options", "menuAccount")
	if value == 0 then
		return "off"
	elseif value == 1 then
		return "on"
	else
		return "unknown"
	end
end

return options
