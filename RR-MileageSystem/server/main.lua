ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local vehicles = nil
local WaitTime = 0
local minutes  = 60000



ESX.RegisterServerCallback('RR-MileagSystem:getVehiclesPlease', function(source, cb)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local vehicles = {}
	local result   = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles')
	
		for i=1, #result, 1 do
			local vehicle = result[i]
			table.insert(vehicles, {vehicle = vehicle})
		end
		cb(vehicles)
end)


CreateThread(function()
	while true do
		Wait(1 * minutes)
		if WaitTime > 0 then
			WaitTime = WaitTime - minutes
		end
	end

end)

RegisterServerEvent('RR:UpdateMiles')
AddEventHandler('RR:UpdateMiles', function(plate, miles)
	local result   = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles')
    for i = 1, #result, 1 do
        if result[i].plate == plate then
            MySQL.Async.execute("UPDATE owned_vehicles SET miles = @miles WHERE plate = @plate",{
                ['@plate'] = plate,
                ['@miles'] = tonumber(result[i].miles + miles)
            })
            result[i].miles = (result[i].miles + miles)
        end
	end
end)