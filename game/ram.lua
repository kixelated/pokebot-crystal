local ram = {}

function ram.byte(addr)
	return memory.readbyte(addr)
end

-- Helper that creates an anoymous function.
local function byteF(addr)
	return function() ram.byte(addr) end
end

-- Menu
ram.menuSelection = byteF(0xcf74)
ram.menuCursorBuffer = byteF(0xcf88)
ram.menuCursorY = byteF(0xcfa9)
ram.menuFlags = byteF(0xcf81) -- bit3 = sound disabled,

-- Options
ram.optionsIndex = byteF(0xcf63) -- jumptable index
ram.options = byteF(0xcfcc) -- textSpeed = 0x06, battleScene = 0x80, battleStyle = 0x40
ram.optionsMenuAccount = byteF(0xcfd1)

-- Overworld
ram.warpNumber = byteF(0xdcb4)
ram.mapGroup = byteF(0xdcb5)
ram.mapNumber = byteF(0xdcb6)
ram.mapY = byteF(0xdcb7)
ram.mapX = byteF(0xdcb8)

-- Visual
ram.overworldDelay = byteF(0xcfb1)
ram.textDelayFrames = byteF(0xcfb2)
ram.vBlankOccurred = byteF(0xcfb3)
ram.farCallBCBuffer = byteF(0xcfb9)

-- Temp
ram.initHourBuffer = byteF(0xc61c)
ram.initMinuteBuffer = byteF(0xc626)

ram.stringBuffer2Char2 = byteF(0xd087)
ram.stringBuffer2Char3 = byteF(0xd088)

-- Tilemap
ram.tileDialogAdvance = byteF(0xc606)

-- Highram
ram.inMenu = byteF(0xffaa)

return ram
