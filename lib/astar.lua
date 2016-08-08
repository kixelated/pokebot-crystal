local astar = {}

local function reconstructPath(node, cameFrom) 
	local path = {}

	while node ~= nil do
		table.insert(path, node)
		node = cameFrom[node]
	end
	
	return path
end

local function leastNode(nodes)
	local leastNode = nil
	local leastValue = nil

	for node, value in pairs(nodes) do
		if leastNode == nil or value < leastValue then
			leastNode = node
			leastValue = value
		end
	end

	return leastNode, leastValue
end

local function findNode(node, nodes, equalFunc)
	for key, value in pairs(nodes) do
		if equalFunc(key, node) then
			return key, value
		end
	end

	return nil
end

function astar.find(start, goal, equalFunc, nextFunc, costFunc, heuristicFunc)
	local gScore = {}
	local fScore = {}

	local closedSet = {}
	local cameFrom = {}

	gScore[start] = 0
	fScore[start] = heuristicFunc(start, goal)

	while true do
		local currentNode = leastNode(fScore)
		if currentNode == nil then
			return
		end

		if equalFunc(currentNode, goal) then
			return reconstructPath(currentNode, cameFrom)
		end

		closedSet[currentNode] = true

		local newNodes = nextFunc(currentNode)
		for i, newNode in ipairs(newNodes) do
			if findNode(newNode, closedSet, equalFunc) == nil then
				local newScore = gScore[currentNode] + costFunc(currentNode, newNode)
				local oldNode, oldScore = findNode(newNode, gScore, equalFunc)

				if oldNode == nil or newScore < oldScore then
					if oldNode ~= nil then
						-- steal the old node's spot in the table instead of replacing (they are equal)
						newNode = oldNode
					end

					gScore[newNode] = newScore
					fScore[newNode] = newScore + heuristicFunc(newNode, goal)
					cameFrom[newNode] = currentNode
				end
			end
		end

		gScore[currentNode] = nil
		fScore[currentNode] = nil
	end

	return nil
end

return astar
