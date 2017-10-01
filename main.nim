import gambatte_wrapper
import sdl2

var gb: GB
discard gb.load("rom/crystal.gbc")

discard sdl2.init(sdl2.INIT_AUDIO or sdl2.INIT_VIDEO)

var window = createWindow("SDL Skeleton", sdl2.SDL_WINDOWPOS_UNDEFINED, sdl2.SDL_WINDOWPOS_UNDEFINED, 320, 288, SDL_WINDOW_SHOWN)
var renderer = createRenderer(window, -1, 0)
var texture = createTexture(renderer, sdl2.SDL_PIXELFORMAT_ARGB8888, sdl2.SDL_TEXTUREACCESS_STREAMING, 160, 144);
var surface = createRGBSurface(160, 144, 8)

var evt = sdl2.defaultEvent
var runGame = true

var bufSamples = 0

var pixels: array[0..(160*144)*2, uint32]
var audio: array[0..(35112+2064)*2, uint32]

discard renderer.setLogicalSize(160, 144)
renderer.setDrawColor(0, 0, 0, 255)
renderer.clear

while runGame:
  while pollEvent(evt):
    if evt.kind == QuitEvent:
      runGame = false
      break

  var doneSamples = -1
  while doneSamples == -1:
    var runSamples: size_t = 35112
    doneSamples = gb.runFor(addr pixels, 160, addr audio, runSamples)

  for i in countup(1, 160*144):
    pixels[i] = pixels[i*2]

  texture.updateTexture(nil, addr pixels, 160*4)

  renderer.clear
  renderer.copy(texture, nil, nil)
  renderer.present

destroy window
destroy renderer
destroy texture
