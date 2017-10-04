import gambatte
import sdl2, sdl2/gfx

type Screen* = object
  window: WindowPtr
  renderer: RendererPtr
  texture: TexturePtr
  fpsman: FpsManager
  audio: pointer

proc init*(self: var Screen) =
  self.window = sdl2.createWindow("Nimtendo", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 320, 288, SDL_WINDOW_SHOWN)
  self.renderer = self.window.createRenderer(-1, Renderer_Software)
  self.texture = self.renderer.createTexture(SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, 160, 144);

  self.fpsman.init()
  self.fpsman.setFrameRate(60)

  self.audio = alloc((35112 + 2064) * sizeof(uint_least32_t))

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

proc handleEvents(self: var Screen, game: var GB): bool =
  var evt = defaultEvent
  while pollEvent(evt):
    case evt.kind:
      of QuitEvent:
        return true
      of KeyDown:
        let button = getButton(evt.key.keysym.sym)
        if button != 0:
          game.setInput(game.getInput() or button)
      of KeyUp:
        let button = getButton(evt.key.keysym.sym)
        if button != 0:
          game.setInput(game.getInput() and not button)
      else: discard

  return false

proc run*(self: var Screen, game: var GB) =
  while true:
    let done = self.handleEvents(game)
    if done:
      return

    var pixels: pointer
    var pitch: cint
    discard self.texture.lockTexture(nil, addr pixels, addr pitch)

    for i in 1..2:
      var doneSamples = -1
      while doneSamples == -1:
        var runSamples: size_t = 35112
        doneSamples = game.runFor(pixels, 160, self.audio, runSamples)

    self.texture.unlockTexture()

    self.fpsman.delay

    self.renderer.copy(self.texture, nil, nil)
    self.renderer.present()

proc destroy*(self: var Screen) =
  destroy(self.window)
  destroy(self.renderer)
  destroy(self.texture)
  dealloc(self.audio)
