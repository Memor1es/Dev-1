ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local vehicles = nil
local WaitTime = 0
local minutes  = 60000

ESX.RegisterServerCallback('RR-MileagSystem:getVehiclesPlease', function(source, cb)
	MySQL.ready(function ()
		local result = (MySQL.Sync.fetchScalar('SELECT * FROM owned_vehicles'))
		local _source  = source
		local xPlayer  = ESX.GetPlayerFromId(_source)
		local vehicles = {}
		
		for i=1, #result, 1 do
			local vehicle = result[i]
				table.insert(vehicles, {vehicle = vehicle})
			end
		end
	end)
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
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate, @miles = miles', {
		['@plate'] = plate,
		['@miles'] = miles
	},  function (result)
		    if result[1] ~= nil then
			    MySQL.Sync.execute("UPDATE owned_vehicles SET miles=@miles WHERE plate=@plate",{
			        ['@miles'] = result[1].miles + miles, 
			        ['@plate'] = plate
				})
			end
		end
	)		
end)