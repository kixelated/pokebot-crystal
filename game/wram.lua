local wram = {}

function wram.byte(addr)
	memory.usememorydomain("WRAM")
	return memory.readbyte(addr)
end

function wram.word(addr)
	memory.usememorydomain("WRAM")
	return memory.read_u16_le(addr)
end

function wram.byteF(addr)
	return function()
		return wram.byte(addr)
	end
end

function wram.wordF(addr)
	return function()
		return wram.word(addr)
	end
end

return wram
