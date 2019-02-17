onMission = false

blips = {}
peds = {}
pickups = {}

lastDoor = 1
currentVan = nil

shouldDraw = false

missionVehicles = {
	"boxville",
	"boxville2",
	"boxville3",
	"boxville4"
}

CreateThread(function()
	if not HasStreamedTextureDictLoaded('timerbars') then
		RequestStreamedTextureDict('timerbars')
		while not HasStreamedTextureDictLoaded('timerbars') do
			Wait(0)
		end
	end
	
	-- load ipls
	RequestIpl("hei_hw1_blimp_interior_v_studio_lo_milo_")
	RequestIpl("hei_hw1_blimp_interior_v_apart_midspaz_milo_")

	while true do
		Wait(0)
		
		-- if pressed E in a vehicle and not onMission
		if IsControlJustPressed(0, 51) and not onMission and IsPedInAnyVehicle(PlayerPedId()) then
			local veh = GetVehiclePedIsIn(PlayerPedId(), false)
			
			if IsMissionVehicle(GetEntityModel(veh)) then
				local time = TimeToSeconds(GetClockTime())
				
				-- check time
				if time >= 0 and time <= TimeToSeconds(5, 30, 0) then
					onMission = true
					
					-- spawn blips
					for _,door in pairs(doors) do
						local blip = AddBlipForCoord(door.coords.x, door.coords.y, door.coords.z)
						SetBlipSprite(blip, 40)
						SetBlipColour(blip, 1)
						SetBlipAsShortRange(blip, true)
						
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString("House")
						EndTextCommandSetBlipName(blip)
						
						table.insert(blips, blip)
					end
					
					currentVan = VehToNet(veh)
					SetEntityAsMissionEntity(veh, false, false)
					
					ShowMPMessage("Burglary", "Find a ~r~house ~s~to rob.", 3500)
					--ShowSubtitle("Find a ~r~house ~s~ to rob")
				else
					DisplayHelpText("Burglary missions can only be started from 0:00 - 5:30 AM.")
				end
			end
		end
		
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		
		if onMission then
			-- maths to calculate time until daylight
			local hours, minutes, seconds = GetClockTime()
			local left = TimeToSeconds(5, 30, 0) - TimeToSeconds(hours, minutes, seconds)
			local time = SecondsToTime(left)
			
			-- draw info
			DrawTimerBar("ITEMS", #stolenItems, 2)
			DrawTimerBar("DAYLIGHT", AddLeadingZero(time.hours) .. ":" .. AddLeadingZero(time.minutes), 1)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		
		if onMission then		
			for k,door in pairs(doors) do
				-- draw marker
				if Vdist(coords, door.coords.x, door.coords.y, door.coords.z) < 100 then
					DrawMarker(0, door.coords.x, door.coords.y, door.coords.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 204, 255, 0, 50, true, true, 2, nil, nil, false)
				end
				
				-- can enter
				if Vdist(coords, door.coords.x, door.coords.y, door.coords.z) < 2 then
					DisplayHelpText("Press ~INPUT_CONTEXT~ to enter this house.")
					
					if IsControlJustPressed(0, 51) then
						local house = houses[door.house]
						
						SetEntityCoords(PlayerPedId(), house.coords.x, house.coords.y, house.coords.z)
						SetEntityHeading(PlayerPedId(), house.coords.heading)
						
						lastDoor = k
						shouldDraw = true
						
						SpawnResidents(door.house)
						
						SpawnPickups(door.house, k)
						
						ShowSubtitle("You are in the house now, be carefull to not make too much noise. (sneaking)")
					end
				end
			end
		end
		
		-- check inside
		for _,house in pairs(houses) do
			--DrawBox(house.area[1], house.area[2], 255, 255, 255, 50)
			if IsEntityInArea(PlayerPedId(), house.area[1], house.area[2], 0, 0, 0) and shouldDraw then
				if onMission then
					DrawNoiseBar(GetPlayerCurrentStealthNoise(PlayerId()), 3)
				end
				
				-- draw exit doors in houses (even if not in mission)
				DrawMarker(0, house.door, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 204, 255, 0, 50, true, true, 2, nil, nil, false)
				
				if Vdist(coords, house.door) < 1 then
					local door = doors[lastDoor]
				
					SetEntityCoords(PlayerPedId(), door.coords.x, door.coords.y, door.coords.z)
					RemoveResidents()
					RemovePickups()
					
					shouldDraw = false
					
					-- play holding anim if holding something after teleported outside
					if isHolding then
						TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "walk", 1.0, 1.0, -1, 1 | 16 | 32, 0.0, 0, 0, 0)
					end
				end
			end
		end
	end
end)

function SpawnPickups(house, door)
	for k,pickup in pairs(houses[house].pickups) do
		if not IsAlreadyStolen(door, k) then
			-- spawn prop
			RequestModel(pickup.model)
			
			while not HasModelLoaded(pickup.model) do
				Wait(0)
			end
			
			local prop = CreateObject(GetHashKey(pickup.model), pickup.coord, false, false, false)
			SetEntityHeading(prop, pickup.rotation)
			
			-- create blip
			local blip = AddBlipForCoord(pickup.coord)
			SetBlipColour(blip, 2)
			SetBlipScale(blip, 0.7)
			
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(pickup.model)
			EndTextCommandSetBlipName(blip)
			
			table.insert(pickups, {
				blip = blip,
				prop = prop,
				item = { house = house, id = k, door = door }
			})
		end
	end
end

function RemovePickups()
	for k,pickup in pairs(pickups) do
		RemoveBlip(pickup.blip)
		
		SetObjectAsNoLongerNeeded(pickup.prop)
		DeleteObject(pickup.prop)
	end
	
	pickups = {}
end

function SpawnResidents(house)
	for _,resident in pairs(residents) do
		if resident.house == house then
			RequestModel(resident.model)
		
			while not HasModelLoaded(resident.model) do 
				Wait(0)
			end
			
			local ped = CreatePed(4, resident.model, resident.coord, resident.rotation, false, false)
			table.insert(peds, ped)
			
			-- animation
			RequestAnimDict(resident.animation.dict)
	
			while not HasAnimDictLoaded(resident.animation.dict) do 
				Wait(0) 
			end
			
			if resident.aggressive then
				GiveWeaponToPed(ped, GetHashKey("WEAPON_PISTOL"), 255, true, false)
			end
			
			TaskPlayAnimAdvanced(ped, resident.animation.dict, resident.animation.anim, resident.coord, 0.0, 0.0, resident.rotation, 8.0, 1.0, -1, 1, 1.0, true, true)
			SetFacialIdleAnimOverride(ped, "mood_sleeping_1", 0)
			
			SetPedHearingRange(ped, 3.0)
			SetPedSeeingRange(ped, 0.0)
			SetPedAlertness(ped, 0)
		end
	end
end

function RemoveResidents()
	for k,ped in pairs(peds) do
		SetPedAsNoLongerNeeded(ped)
		DeletePed(ped)
	end
	
	peds = {}
end

function IsAlreadyStolen(door, id)
	for _,v in pairs(stolenItems) do
		if v.door == door and v.id == id then
			return true
		end
	end
	
	return false
end

function GetCurrentHouse()
	for index,house in pairs(houses) do
		if IsEntityInArea(PlayerPedId(), house.area[1], house.area[2], 0, 0, 0) then
			return true, index
		end
	end
	
	return false, index
end

function RemoveBlips()
	for _,blip in pairs(blips) do
		RemoveBlip(blip)
	end
	
	blips = {}
end

function IsMissionVehicle(model)
	for _,v in pairs(missionVehicles) do
		if model == GetHashKey(v) then
			return true
		end
	end
	
	return false
end