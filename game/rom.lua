local rom = {}

function rom.byte(addr)
	return memory.readbyte(addr, "ROM")
end

function rom.bytes(addr, size)
	return memory.readbyterange(addr, size, "ROM")
end

function rom.word(addr)
	return memory.read_u16_le(addr, "ROM")
end

return rom
