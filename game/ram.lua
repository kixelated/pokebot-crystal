local ram = {}

local wram = require "game.wram"
local hram = require "game.hram"

-- Joypad
ram.joyReleased = hram.byteF(0xa6)
ram.joyPressed = hram.byteF(0xa7)
ram.joyDown = hram.byteF(0xa8)
ram.joyLast = hram.byteF(0xa9)

-- Menu
ram.menuSelection = wram.byteF(0x0f74)
ram.menuCursorBuffer = wram.byteF(0x0f88)
ram.menuCursorY = wram.byteF(0x0fa9)
ram.menuCursorX = wram.byteF(0x0faa)
ram.menuFlags = wram.byteF(0x0f81)

-- Options
ram.optionsIndex = wram.byteF(0x0f63) -- jumptable index
ram.options = wram.byteF(0x0fcc) -- textSpeed = 0x06, battleScene = 0x80, battleStyle = 0x40
ram.optionsMenuAccount = wram.byteF(0x0fd1)

-- Overworld
ram.warpNumber = wram.byteF(0x1cb4)
ram.mapGroup = wram.byteF(0x1cb5)
ram.mapNumber = wram.byteF(0x1cb6)
ram.mapY = wram.byteF(0x1cb7)
ram.mapX = wram.byteF(0x1cb8)

-- Visual
ram.overworldDelay = wram.byteF(0x0fb1)
ram.textDelayFrames = wram.byteF(0x0fb2)
ram.vBlankOccurred = wram.byteF(0x0fb3)
ram.farCallBCBuffer = wram.byteF(0x0fb9)

-- Temp
ram.initHourBuffer = wram.byteF(0x061c)
ram.initMinuteBuffer = wram.byteF(0x0626)

-- Tilemap
ram.tileDialogAdvance = wram.byteF(0x0606)

-- Highram
ram.inMenu = hram.byteF(0xaa)

return ram
