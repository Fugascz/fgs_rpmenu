--[[

    CREATED BY FGS
	THX FOR HELP KPS <3
	
]]

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(1)
	end
	if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	Wait(1)
  	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	Wait(1)
	ESX.PlayerData.job = job
end)

RegisterKeyMapping('rpmenu', "RP Menu", "keyboard", "F11")
RegisterCommand('rpmenu', function()
	RPMenu()
end)

function RPMenu()
	local elements = {}

	if ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = 'Faktury', value = 'billing'})
		table.insert(elements, {label = 'Portfolio', value = 'portfolio'})
		table.insert(elements, {label = 'Interakce s vozidlem', value = 'car_menu'})
		table.insert(elements, {label = 'Frakční informace', value = 'fractionInfo'})
		table.insert(elements, {label = 'Zavřít menu', value = 'zavrit_menu'})
	else
		table.insert(elements, {label = 'Faktury', value = 'billing'})
		table.insert(elements, {label = 'Portfolio', value = 'portfolio'})
		table.insert(elements, {label = 'Interakce s vozidlem', value = 'car_menu'})
		table.insert(elements, {label = 'Zavřít menu', value = 'zavrit_menu'})
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu', {
		title = 'RP Menu',
		align    = 'right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'billing' then
			ExecuteCommand('showbills')
		elseif data.current.value == 'portfolio' then
			portfolio()
		elseif data.current.value == 'car_menu' then
			ExecuteCommand('carmenu')
		elseif data.current.value == 'fractionInfo' then
			frakcniInfo()
		elseif data.current.value == 'zavrit_menu' then
			menu.close()
		end	
	end, function(data, menu)
		menu.close()
	end)
end

function frakcniInfo()
	ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
		local fractionName = string.format('Název frakce: %s', ESX.PlayerData.job.label)
		local fractionMoney = string.format('Frakční peníze: %s', money)

		local elements = {
			{label = fractionName},
			{label = fractionMoney},
			{label = 'Zavřít menu', value = 'zavrit_menu'},
		}

		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'frakcni-info', {
		title    = 'Frakční informace',
			align    = 'right',
			elements = elements
		}, function(data2, menu2)
			if data2.current.value == 'zavrit_menu' then
				menu2.close()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end)
end

function portfolio()
	ESX.TriggerServerCallback('fgs-rpmenu:getPlayerData', function(data)
		local playerId = PlayerId()
		local elements = {
			{label = string.format('Tvoje ID: %s', GetPlayerServerId(playerId))},
			{label = string.format('Steam jméno: %s', GetPlayerName(playerId))},
			{label = string.format('Jméno postavy: %s', data.name)},
			{label = string.format('Zaměstání: %s - %s', ESX.PlayerData.job.label, ESX.PlayerData.job.grade_label)},
			{label = string.format('Datum narození: %s', data.dob)},
			{label = 'Zavřít menu', value = 'zavrit_menu'}
		}
		
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'portfolio', {
			title    = 'Portfolio',
			align    = 'right',
			elements = elements
		}, function(data2, menu2)
			if data2.current.value == 'zavrit_menu' then
				menu2.close()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end)
end

AddEventHandler('onResourceStop', function()
	ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'portfolio')
	ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'frakcni-info')
	ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menu')
end)

