local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                 = nil
local PlayerData    = {}
local seconde       = 1000
local vehicle       = nil
local timer         = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

Citizen.CreateThread(
	function()
		while true do 
			Citizen.Wait(1000)
			ESX.TriggerServerCallback('RR-MileagSystem:getVehiclesPlease', function (vehicles)
				for i=1, #vehicles, 1 do
					local vehicle      = vehicles[i].vehicle
					local VehDecode    = json.decode(vehicle.vehicle)
					local miles        = vehicle.miles 
					local plate        = vehicle.plate
					local owner        = vehicle.owner 
					local player       = GetPlayerPed(-1)
					local vehicleS     = GetVehiclePedIsIn(player, false)
					local VehicleT     = ESX.Game.GetVehicleProperties(vehicleS)
					if IsPedInAnyVehicle(player, true) then 
						if GetPedInVehicleSeat(vehicleS, -1) then 
							if IsVehicleEngineOn(vehicleS) then
								Citizen.Wait(Config.UpdateTime) 
								miles = miles + 1 
								TriggerServerEvent('RR:UpdateMiles', VehicleT.plate, miles)
							end
						end
					end
				end
			end)
		end
	end
)

local uix = 0.01135
local uiy = 0.002

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        ESX.TriggerServerCallback('RR-MileagSystem:getVehiclesPlease', function (vehicles)
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                RefreshList()
                local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                local prop = ESX.Game.GetVehicleProperties(veh)
                    if IsPlateInList(prop.plate) then
                    local RRVehicle = GetPlateFromList(prop.plate)
                    drawRct(0.097 - uix, 0.95 - uiy, 0.046, 0.03, 0, 0, 0, 150)
                    DrawAdvancedText(0.171 - uix, 0.957 - uiy, 0.005, 0.0028, 0.3, "Mileage ~b~[ "..tostring(vehicle.miles).." ]~s~", 255, 255, 255, 255, 9, 1)
                end
            end
        end)
    end
end)

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1+w, y - 0.02+h)
end

function IsPlateInList(plate)
	ESX.TriggerServerCallback('RR-MileagSystem:getVehiclesPlease', function (vehicles)

        for i = 1, #vehicles, 1 do
            if vehicles[i].plate == plate then
                return true
            end
        end
		return false
	end)
end

function GetPlateFromList(plate)
	ESX.TriggerServerCallback('RR-MileagSystem:getVehiclesPlease', function (vehicles)
        for i = 1, #vehicles, 1 do
            if vehicles[i].plate == plate then
                return vehicles[i]
            end
        end
		return nil
	end)
end

function RefreshList()
    ESX.TriggerServerCallback('RR-MileagSystem:getVehiclesPlease', function(vehicles)
        vehicles = {}
        vehicles = vehicles
    end)
end