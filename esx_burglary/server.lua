-- ESX implementation for burglary script

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler("burglary:money", function(sum, player)
	local xPlayer = ESX.GetPlayerFromId(player)
	
	if Config.GiveBlack then
		xPlayer.addAccountMoney('black_money', sum)
	else
		xPlayer.addMoney(sum)
	end
end)

AddEventHandler("burglary:failed", function(house, coords, player)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.getJob().name == "police" and Config.AlertPolice then
			TriggerClientEvent("esx_burglary:police", xPlayers[i], coords, Config.BlipTime)
		end
	end
end)