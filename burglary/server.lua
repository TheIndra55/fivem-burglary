local robbers = {}

-- functions
function onNet (name, func)
    RegisterNetEvent(name)
    return AddEventHandler(name, func)
end

function insert(id, item)
    if not robbers[id] then
        robbers[id] = {}
    end

    table.insert(robbers[id], item)
end

-- events
onNet('burglary:collected', function (item, house)
	insert(source, { item = item, house = house })
end)

onNet('burglary:ended', function (failed, alert, door, street)
	if not failed then
		if robbers[source] then
			local sum = 0
			
			for _,v in pairs(robbers[source]) do
				-- get price from houses/pickups table
				local item = houses[v.house].pickups[v.item]
			
				if tonumber(item.value) ~= nil then
					sum = sum + item.value
				end
			end
			
			print("[Burglary] " .. GetPlayerName(source) ..  " stole " .. #robbers[source] .. " items with a value of $" .. sum)
			robbers[source] = nil
			
			-- tell the client how much money he made
			TriggerClientEvent("burglary:finished", source, sum)
			
			-- resources can listen for this event to give money using their own framework
			-- sum = amount of money
			-- source = source of player
			TriggerEvent("burglary:money", sum, source)
		end
	else
		if alert then
			-- resources can listen for this event to for example alert cops
			-- house = houseid
			-- coords = door coordinates of house
			-- source = source of player failing
			TriggerEvent("burglary:failed", doors[door].house, doors[door].coords, source, street)
		end
		
		if robbers[source] then
			robbers[source] = nil
		end
	end
end)

AddEventHandler('playerDropped', function (source, reason)
    if robbers[source] then
        robbers[source] = nil
    end
end)