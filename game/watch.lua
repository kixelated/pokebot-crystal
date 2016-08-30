local watch = {}

local hram = require "game.hram"

local queue = {}

function watch.push(func)
	table.insert(queue, func)
end

function watch.pop()
	return table.remove(queue, 1)
end

function watch.yield()
	local func = watch.pop()
	while func ~= nil do
		func()
		func = watch.pop()
	end
end

-- Watch for a rom address to be executed, including support for banks.
function watch.onexecute(address, luaf)
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

		watch.push(luaf)
	end

	return event.onmemoryexecute(wrapper, address)
end

function watch.remove(id)
	return event.unregisterbyid(id)
end

return watch
