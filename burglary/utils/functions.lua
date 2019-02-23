function AddLeadingZero(number)
	if number <= 9 then
		return "0" .. number
	end
	
	return number
end

function GetClockTime()
	return GetClockHours(), GetClockMinutes(), GetClockSeconds()
end

function SecondsToTime(seconds)
    local hou = math.floor(seconds / 3600)
    local min = math.floor(seconds / 60 - (hou * 60))
    local sec = math.floor(seconds - hou * 3600 - min * 60)
    
    return { seconds = sec, minutes = min, hours = hou}
end

function TimeToSeconds(hou, min, sec)
    sec = sec + (min * 60)
    sec = sec + (hou * 60 * 60)
    
    return sec
end

function GetStreet(x, y, z)
	local streetHash = GetStreetNameAtCoord(x, y, z)
	
	return GetStreetNameFromHashKey(streetHash)
end