local watch = {}

local hram = require "game.hram"

-- Watch for a rom address to be executed, including support for banks.
function watch.execute(luaf, address)
	local bank = math.floor(address / 0x4000)
	address = address % 0x4000

	if bank > 0 then
		address = address + 0x4000
	end
 
	local wrapper = function()
		if bank > 0 then
			local hbank = hram.byte(0x9d)
			if bank ~= hbank then
				return
			end
		end

		luaf()
	end

	return event.onmemoryexecute(wrapper, address)
end

return watch
