--[[

    CREATED BY FGS
	THX FOR HELP KPS <3
	
]]

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('fgs-rpmenu:getPlayerData', function(source, cb)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local data = {
        name = xPlayer.getName(),
        dob = xPlayer.get('dateofbirth')
    }
 
    cb(data)
end)
