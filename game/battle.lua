local battle = {}

local input = require "game.input"
local menu = require "game.menu"
local dialog = require "game.dialog"
local wram = require "game.wram"

function battle.start()
	dialog.advance()
end

function battle.run()
	-- TODO check if success
	menu.pick("RUN")
	dialog.advance()
end

function battle.finish()
	while wram.byte(0x122d) ~= 0 do
		input.wait()
	end
end

return battle
