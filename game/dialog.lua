local dialog = {}

local player = require "game.player"

function dialog.advance(times)
	for i=1,times do
		while mainmemory.readbyte(0x0606) ~= 238 do
			player.wait()
		end

		while mainmemory.readbyte(0x0606) == 238 do
			player.press("A")
		end
	end
end

function dialog.advanceSpecial()
	while mainmemory.readbyte(0x0fcf) ~= 1 do
		player.wait()
	end

	while mainmemory.readbyte(0x0606) == 122 do
		player.press("A")
	end
end

function dialog.selectYes()
	while mainmemory.readbyte(0x0fb2) ~= 0 do
		player.wait()
	end

	while mainmemory.readbyte(0x0fb2) == 0 do
		player.press("A")
	end
end

return dialog
