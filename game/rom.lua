local rom = {}

function rom.byte(addr)
	memory.usememorydomain("ROM")
	return memory.readbyte(addr)
end

function rom.word(addr)
	memory.usememorydomain("ROM")
	return memory.read_u16_le(addr)
end

return rom
