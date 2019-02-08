blips = {}

function ShowNotification(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end

RegisterNetEvent("esx_burglary:police")

AddEventHandler("esx_burglary:police", function(coords, blipTime)
	local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
	local street = GetStreetNameFromHashKey(streetHash)

	ShowNotification("~r~Active burglary at ~w~" .. street .. " street")
	
	local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 75.0)
	SetBlipSprite(blip,  9)
	SetBlipColour(blip,  1)
	SetBlipAlpha(blip,  80)
	SetBlipAsShortRange(blip,  1)
	
	local blip2 = AddBlipForCoord(coords.x, coords.y, coords.z)
	
	SetBlipSprite(blip2,  40)
	SetBlipColour(blip2,  1)
	SetBlipAsShortRange(blip2,  1)
	
	SetBlipFlashes(blip2, true)
	SetBlipFlashTimer(blip2, 3500)
	
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Burglary")
	EndTextCommandSetBlipName(blip2)
	
	table.insert(blips, { gone = GetGameTimer() + blipTime, blip = blip })
	table.insert(blips, { gone = GetGameTimer() + blipTime, blip = blip2 })
end)

CreateThread(function()
	while true do
		Wait(1000)
		for k,v in pairs(blips) do
			if  GetGameTimer() > v.gone then
				RemoveBlip(v.blip)
				
				blips[k] = nil
			end
		end
	end
end)