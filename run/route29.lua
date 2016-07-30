local route29 = {}

local player = require "game.player"

function route29.run()
	player.moveTo(59, 8) -- starting position
	player.moveTo(44, 8)
	player.moveTo(44, 14)
	player.moveTo(38, 14)
	player.moveTo(31, 16)
	player.moveTo(31, 10)
	player.moveTo(36, 10)
	player.moveTo(36, 6)
	player.moveTo(31, 6)
	player.moveTo(21, 6)
	player.moveTo(21, 3)
	player.moveTo(16, 3)
	player.moveTo(16, 7)
	player.moveTo(14, 7)
	player.moveTo(14, 8)
	player.moveTo(4, 8)
	player.moveTo(4, 7)
	player.moveTo(0, 7)
	player.move("Left")
end

return route29
