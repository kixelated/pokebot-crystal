local player = {}

local wram = require "game.wram"
local input = require "game.input"

function player.moveTo(x, y, onBattle)
	console.log("moveTo", x, y)
	while true do
		local battleType = wram.byte(0x122d)
		if battleType ~= 0 then
			console.log("battle start")
			onBattle()
		elseif wram.byte(0x1cb8) > x then
			input.raw("Left")
		elseif wram.byte(0x1cb8) < x then
			input.raw("Right")
		elseif wram.byte(0x1cb7) > y then
			input.raw("Up")
		elseif wram.byte(0x1cb7) < y then
			input.raw("Down")
		else
			break
		end
	end
end

function player.move(direction)
	local addr
	if direction == "Down" or direction == "Up" then
		addr = 0x1cb7
	else
		addr = 0x1cb8
	end

	local curr = wram.byte(addr)
	while wram.byte(addr) == curr do
		input.raw(direction)
	end
end

function player.face(direction)
	local map = {
		Down = 0,
		Up = 4,
		Left = 8,
		Right = 12,

	}

	if wram.byte(0x14de) == map[direction] then
		return
	end

	-- Wait until we stop moving first.
	while wram.byte(0x1044) ~= 0 do
		input.wait()
	end

	input.press(direction)
end

function player.interact()
	-- Wait until we stop moving first.
	while wram.byte(0x1044) ~= 0 do
		input.wait()
	end

	input.press("A")
end

function player.wait()
	input.wait()
end

return player
