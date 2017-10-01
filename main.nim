import gambatte_wrapper as gambatte
import sdl2

var gb: GB
discard gb.load("rom/crystal.gbc")

discard gb.getInput()

discard sdl2.init(INIT_VIDEO)

var window = sdl2.createWindow("Nimtendo", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 320, 288, SDL_WINDOW_SHOWN)
var renderer = window.createRenderer(-1, 0)
var texture = renderer.createTexture(SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, 160, 144);

renderer.setDrawColor(0, 0, 0, 255)
renderer.clear()

var evt = defaultEvent
var runGame = true

var bufSamples = 0

var audio = alloc((35112 + 2064) * sizeof(uint_least32_t))

proc getButton(key: cint): cuint =
  case key:
    of K_d:
      return gambatte.BUTTON_A
    of K_c:
      return gambatte.BUTTON_B
    of K_RSHIFT:
      return gambatte.BUTTON_SELECT
    of K_RETURN:
      return gambatte.BUTTON_START
    of K_RIGHT:
      return gambatte.BUTTON_RIGHT
    of K_LEFT:
      return gambatte.BUTTON_LEFT
    of K_UP:
      return gambatte.BUTTON_UP
    of K_DOWN:
      return gambatte.BUTTON_DOWN
    else:
      return 0

while runGame:
  while pollEvent(evt):
    case evt.kind:
      of QuitEvent:
        runGame = false
        break
      of KeyDown:
        let button = getButton(evt.key.keysym.sym)
        if button != 0:
          gb.setInput(gb.getInput() or button)
      of KeyUp:
        let button = getButton(evt.key.keysym.sym)
        if button != 0:
          gb.setInput(gb.getInput() and not button)
      else: discard

  var pixels: pointer
  var pitch: cint
  discard texture.lockTexture(nil, addr pixels, addr pitch)

  var doneSamples = -1
  while doneSamples == -1:
    var runSamples: size_t = 35112
    doneSamples = gb.runFor(pixels, 160, audio, runSamples)

  texture.unlockTexture()

  renderer.copy(texture, nil, nil)
  renderer.present()

dealloc(audio)

destroy(window)
destroy(renderer)
destroy(texture)

sdl2.quit()
