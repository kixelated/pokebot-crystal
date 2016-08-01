local bus = {}

local rom = require "game.rom"
local wram = require "game.wram"
local hram = require "game.hram"

function bus.map(addr, bank)
	if addr >= 0x0000 and addr < 0x4000 then
		return rom, addr
	end

	if addr >= 0x4000 and addr < 0x8000 then
		return rom, (addr - 0x4000) + (bank * 0x4000)
	end

	if addr >= 0xc000 and addr < 0xd000 then
		return wram, addr - 0xc000
	end

	if addr >= 0xd000 and addr < 0xe0000 then
		return wram, (addr - 0xd000) + (bank * 0x1000)
	end

	if addr >= 0xff00 then
		return hram, addr - 0xff00
	end

	error("unknown memory address"..addr)
end

function bus.byte(addr, bank)
	map, addr = bus.map(addr, bank)
	return map.byte(addr)
end

function bus.word(addr, bank)
	map, addr = bus.map(addr, bank)
	return map.word(addr)
end

return bus
