RegisterNetEvent("burglary:finished")

CreateThread(function()
	while true do
		Wait(0)
		
		-- if time is up
		if TimeToSeconds(GetClockTime()) > TimeToSeconds(5, 30, 0) and onMission then
			-- if still in the house
			if GetCurrentHouse() then
				-- mission failed we'll get em next time
				ShowMPMessage("~r~Burglary failed", "You didn't leave the house before daylight.", 3500)
				TriggerServerEvent("burglary:ended", true, lastDoor)
			else
				-- player made it before time
				TriggerServerEvent("burglary:ended", false)
			end
			
			ForceEndMission()
		end

		if onMission then		
			if CanPedHearPlayer(PlayerId(), peds[1]) then
				ShowMPMessage("~r~Burglary failed", "You woke up a resident.", 3500)
				TriggerServerEvent("burglary:ended", true, lastDoor)
				
				ClearPedTasks(peds[1])
				PlayPain(peds[1], 7, 0)
				
				-- if resident is aggresive
				if HasPedGotWeapon(peds[1], GetHashKey("WEAPON_PISTOL"), false) then
					SetCurrentPedWeapon(peds[1], GetHashKey("WEAPON_PISTOL"), true)
					
					TaskShootAtEntity(peds[1], PlayerPedId(), -1, 2685983626)
				end
				
				ForceEndMission()
			end
		end
		
		if IsPedCuffed(PlayerPedId()) and onMission then
			ShowMPMessage("~r~Burglary failed", "You got arrested.", 3500)
			
			ForceEndMission()
		end
		
		-- check if van is not destroyed
		if IsEntityDead(currentVan) and onMission then
			ShowMPMessage("~r~Burglary failed", "Your van got destroyed.", 3500)
			
			ForceEndMission()
		end
	end
end)

function ForceEndMission()
	if isHolding then
		DetachEntity(holdingProp)
	end
	
	-- lot of cleanup
	isHolding = false
	holdingProp = nil
	
	stolenItems = {}
	currentItem = {}
	
	-- reset anim
	ClearPedTasks(PlayerPedId())
	SetPedCanSwitchWeapon(PlayerPedId(), not isHolding)
	
	onMission = false
	
	RemoveBlips()
	RemovePickups()
end

AddEventHandler("burglary:finished", function(sum)
	ShowMPMessage("~g~Burglary successful", "You sold all your items for a value of $" .. sum, 3500)
end)