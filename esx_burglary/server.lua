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

AddEventHandler("burglary:failed", function(house, coords, player, street)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.getJob().name == "police" and Config.AlertPolice then
			TriggerClientEvent("esx_burglary:police", xPlayers[i], coords, Config.BlipTime)
		end
	end
	
	-- discord webhook
	if Config.DiscordWebhook then
		-- get player who did burglary
		local xBurglar = ESX.GetPlayerFromId(player)
		
		-- request burglar skin for suspect description
		MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
			['@identifier'] = xBurglar.identifier
		}, function(users)
			local user = users[1]
			if user.skin ~= nil then
				skin = json.decode(user.skin)
		
				-- the message
				local message = {
					"Active burglary at ", street, " street\n",
					"```",
					"Suspect description: ", skinColors[skin.skin], " ", genders[skin.sex], "\n",
					"Last seen: ", street, " street (", 
					coords.x, " ", coords.y, " ", coords.z,
					")",
					"```"
				}
				
				local headers = {
					["Content-Type"] = "application/json"
				}
				
				-- send message
				PerformHttpRequest(Config.WebhookUrl, function(err, text, headers) 
					if err >= 400 then
						print("An error occurred while sending webhook message, discord returned " .. err)
					end
				end, "POST", json.encode({content = table.concat(message)}), headers)
			end
		end)
	end
end)

genders = {
	-- only 2 genders exists deal with it
	[0] = "Male",
	[1] = "Female"
}

-- don't ask
skinColors = {
	[0] = "White",
	[1] = "White",
	[2] = "Dark",
	[3] = "Dark",
	[4] = "White",
	[5] = "Slightly tinted",
	[6] = "White",
	[7] = "White",
	[8] = "Dark",
	[9] = "Slightly tinted",
	[10] = "White",
	[11] = "White",
	[12] = "White",
	[13] = "White",
	[14] = "Dark",
	[15] = "Dark",
	[16] = "White",
	[17] = "White",
	[18] = "White",
	[19] = "Dark",
	[20] = "White",
	[21] = "Sheet white",
	[22] = "White",
	[23] = "Dark",
	[24] = "Dark",
	[25] = "Dark",
	[26] = "Dark",
	[27] = "White",
	[28] = "White",
	[29] = "Dark",
	[30] = "Dark",
	[31] = "Slightly tinted",
	[32] = "Slightly tinted",
	[33] = "Sheet white",
	[34] = "White",
	[35] = "Dark",
	[36] = "Dark",
	[37] = "Slightly tinted",
	[38] = "White",
	[39] = "White",
	[40] = "White",
	[41] = "Slightly tinted",
	[42] = "White",
	[43] = "White",
	[44] = "White",
	[45] = "White"
}