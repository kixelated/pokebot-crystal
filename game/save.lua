local save = {}

function save.run(index, start, func)
	if index >= start then
		func()
		savestate.save("save/"..index..".state")
	else
		savestate.load("save/"..index..".state")
	end
end


return save
