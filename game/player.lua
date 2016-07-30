local player = {}

local ram = require "game.ram"
local input = require "game.input"

function player.moveTo(x, y)
	while true do
		local pos = ram.byte(0xdcb8)
		if pos == x then
			break
		elseif pos > x then
			input.raw("Left")
		else
			input.raw("Right")
		end
	end

	while true do
		local pos = ram.byte(0xdcb7)
		if pos == y then
			break
		elseif pos > y then
			input.raw("Up")
		else
			input.raw("Down")
		end
	end
end

function player.move(direction)
	local addr
	if direction == "Down" or direction == "Up" then
		addr = 0xdcb7
	else
		addr = 0xdcb8
	end

	local curr = ram.byte(addr)
	while ram.byte(addr) == curr do
		input.raw(direction)
	end
end

function player.face(direction)
	while ram.byte(0xd436) == 0 do -- hits 16 for one frame
		input.raw(direction)
	end
end

return player
