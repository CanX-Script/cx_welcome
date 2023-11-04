ESX = nil
QBCore = nil

if Config.Framework == 'ESX' then
  ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == 'QB' then   
  QBCore = exports['qb-core']:GetCoreObject()
end

local function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', shouldShow)
end

RegisterNUICallback("getCitizenCount", function(data, cb)
  if Config.Framework == 'ESX' then
    ESX.TriggerServerCallback("CanX:GetData", function(count)
      print(count)
      Wait(1000)
      cb(count)
    end)
  elseif Config.Framework == 'QB' then    
    QBCore.Functions.TriggerCallback("CanX:GetData", function(count)
      print(count)
      Wait(1000)
      cb(count)
    end)
  end
end)

RegisterNUICallback("gerReward", function(data, cb)
  -- got - already
  if Config.Framework == 'ESX' then
    ESX.TriggerServerCallback("CanX:GetClaimStatus", function(valid)
      if valid then
        cb({ state = "got" })
        TriggerServerEvent('CanX:ClaimReward', 'default')
      else
        cb({ state = "already" })
      end
    end)
  elseif Config.Framework == 'QB' then    
    QBCore.Functions.TriggerCallback("CanX:GetClaimStatus", function(valid)
      if valid then
        cb({ state = "got" })
        TriggerServerEvent('CanX:ClaimReward', 'default')
      else
        cb({ state = "already" })
      end
    end)
  end
end)
RegisterNUICallback("gerRewardFromCode", function(data, cb)
  -- got - already -- invalid
  if Config.Framework == 'ESX' then
    local Code = data.code
    ESX.TriggerServerCallback("CanX:GetClaimStatus", function(valid)
      if valid then
        ESX.TriggerServerCallback("CanX:CheckValidCode", function(valid_code)
          if valid_code then
            cb({ state = "got" })
            TriggerServerEvent('CanX:ClaimReward', Code)
          else
            cb({ state = "invalid" })
            ESX.ShowNotification('This creator code is not valid!')
          end
        end, Code)
      else
        cb({ state = "already" })
      end
    end)
  elseif Config.Framework == 'QB' then    
    local Code = data.code
    QBCore.Functions.TriggerCallback("CanX:GetClaimStatus", function(valid)
      if valid then
        QBCore.Functions.TriggerCallback("CanX:CheckValidCode", function(valid_code)
          if valid_code then
            cb({ state = "got" })
            TriggerServerEvent('CanX:ClaimReward', Code)
          else
            cb({ state = "invalid" })
            QBCore.Functions.Notify('This creator code is not valid!', 'error')
          end
        end, Code)
      else
        cb({ state = "already" })
      end
    end)
  end
end)

RegisterNUICallback('hideFrame', function(_, cb)
  toggleNuiFrame(false)
  debugPrint('Hide NUI frame')
  cb({})
end)

RegisterNUICallback('getClientData', function(data, cb)
  debugPrint('Data sent by React', json.encode(data))

  -- Lets send back client coords to the React frame for use
  local curCoords = GetEntityCoords(PlayerPedId())

  local retData <const> = { x = curCoords.x, y = curCoords.y, z = curCoords.z }
  cb(retData)
end)

SetEntityCoords(PlayerPedId(), Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z)

Citizen.CreateThread(function()
  local Ped = Config.PedBuyIdCardModel
  RequestModel(Ped)
  while not HasModelLoaded(Ped) do
    Wait(1)
  end
  Ped = CreatePed(1, Ped, Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z, Config.PedLocation.h, false, true)
  SetBlockingOfNonTemporaryEvents(Ped, true)
  SetPedCanPlayAmbientAnims(Ped, true)
  SetEntityInvincible(Ped, true)
  FreezeEntityPosition(Ped, true)
  while true do
    Citizen.Wait(5)
    local MyCoords = GetEntityCoords(PlayerPedId())
    local Sleep = true
    if GetDistanceBetweenCoords(MyCoords, Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z, true) < Config.TextDistance then
      Sleep = false
      if GetDistanceBetweenCoords(MyCoords, Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z, true) < 2 then
        DrawText3Ds(Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z + 2.1,
        'Press ~g~E')
        if IsControlJustPressed(0, 38) then
          toggleNuiFrame(true)
        end
      end
    end
    if Sleep then Citizen.Wait(710) end
  end
end)


function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,250)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end

RegisterNetEvent('CanX:ClaimVehicle', function(veh)
  AddCarForPlayer(veh)
end)

function AddCarForPlayer(veh)
  local PlayerCoords = GetEntityCoords(PlayerPedId())
  SpawnLocalVehicle(veh, vector3(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 100), 50, function(vehicle)
      local Vehicle_Prop 
      if Config.Framework == 'ESX' then
        Vehicle_Prop = ESX.Game.GetVehicleProperties(vehicle)
      elseif Config.Framework == 'QB' then
        Vehicle_Prop = QBCore.Functions.GetVehicleProperties(vehicle)
      end
      TriggerServerEvent('CanX:SetVehicleOwner', Vehicle_Prop, veh)
      Citizen.Wait(2000)
      DeleteEntity(vehicle)
  end)
end

function SpawnLocalVehicle(modelName, coords, heading, cb)
  local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
  Citizen.CreateThread(function()
      Citizen.Wait(100)
      RequestModel(model)
      while not HasModelLoaded(model) do
          Citizen.Wait(1000)
      end
      local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z + 100, heading, false, false)
      FreezeEntityPosition(vehicle, true)
      if cb ~= nil then
          cb(vehicle)
      end
  end)
end