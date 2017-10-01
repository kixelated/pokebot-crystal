import gambatte_wrapper
import sdl2

var gb: GB
discard gb.load("rom/crystal.gbc")

discard sdl2.init(sdl2.INIT_AUDIO or sdl2.INIT_VIDEO)

var window = createWindow("Nimtendo", sdl2.SDL_WINDOWPOS_UNDEFINED, sdl2.SDL_WINDOWPOS_UNDEFINED, 320, 288, SDL_WINDOW_SHOWN)
var renderer = createRenderer(window, -1, 0)
var texture = createTexture(renderer, sdl2.SDL_PIXELFORMAT_ARGB8888, sdl2.SDL_TEXTUREACCESS_STREAMING, 160, 144);

renderer.setDrawColor(0, 0, 0, 255)
renderer.clear

var evt = sdl2.defaultEvent
var runGame = true

var bufSamples = 0

var audio = alloc(35112+2064 * sizeof(uint_least32_t))

while runGame:
  while pollEvent(evt):
    if evt.kind == QuitEvent:
      runGame = false
      break

  var pixels: pointer
  var pitch: cint
  discard texture.lockTexture(nil, addr pixels, addr pitch)

  var doneSamples = -1
  while doneSamples == -1:
    var runSamples: size_t = 35112
    doneSamples = gb.runFor(pixels, 160, audio, runSamples)

  texture.unlockTexture

  renderer.copy(texture, nil, nil)
  renderer.present

dealloc audio

destroy window
destroy renderer
destroy texture
