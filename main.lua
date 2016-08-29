local save = require "game.save"
local intro = require "run.intro"
local newbark = require "run.newbark"
local route29 = require "run.route29"
local cherrygrove = require "run.cherrygrove"
local route30 = require "run.route30"

console.clear()

start = 0
save.run(0, start, intro.run)
save.run(1, start, newbark.run)
save.run(2, start, route29.run)
save.run(3, start, cherrygrove.run)
save.run(4, start, route30.run)
save.run(5, start, cherrygrove.run2)
save.run(6, start, route29.run2)
save.run(7, start, newbark.run2)
