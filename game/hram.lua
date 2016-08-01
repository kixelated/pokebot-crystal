local hram = {}

function hram.byte(addr)
	memory.usememorydomain("HRAM")
	return memory.readbyte(addr - 0x80)
end

function hram.word(addr)
	memory.usememorydomain("HRAM")
	return memory.read_u16_le(addr - 0x80)
end

function hram.byteF(addr)
	return function()
		return hram.byte(addr)
	end
end

function hram.wordF(addr)
	return function()
		return hram.word(addr)
	end
end

return hram
