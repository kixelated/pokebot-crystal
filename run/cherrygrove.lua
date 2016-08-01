local cherrygrove = {}

local player = require "game.player"

function cherrygrove.run()
	player.moveTo(39, 7) -- starting position
	player.moveTo(28, 7)
	player.moveTo(28, 4)
	player.moveTo(17, 4)
	player.moveTo(17, 0)
	player.move("Up")
end

return cherrygrove
