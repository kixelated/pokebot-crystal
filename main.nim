import sdl2
import src/gambatte
import src/screen

discard sdl2.init(INIT_VIDEO)

var game: GB
discard game.load("rom/crystal.gbc")

var s: Screen
s.init()
s.run(game)
s.destroy()

sdl2.quit()
