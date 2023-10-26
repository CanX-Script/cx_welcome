local function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', shouldShow)
end

RegisterNUICallback("getCitizenCount", function(data, cb)
  Wait(1000)
  cb(35632)
end)

RegisterNUICallback("gerReward", function(data, cb)
  -- got - already
  cb({ state = "already" })
end)
RegisterNUICallback("gerRewardFromCode", function(data, cb)
  -- got - already -- invalid
  print("data")
  cb({ state = "already" })
end)

RegisterCommand('show-nui', function()
  toggleNuiFrame(true)
  debugPrint('Show NUI frame')
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


local pedCoords = vector4(219, -815, 29.6, 155)
local pedModel = GetHashKey("a_m_m_business_01")
RequestModel(pedModel)

while not HasModelLoaded(pedModel) do
  Citizen.Wait(0)
end

local ped = CreatePed(4, pedModel, pedCoords, true, true, true)

SetBlockingOfNonTemporaryEvents(ped, true)
SetPedCanPlayAmbientAnims(ped, true)
SetEntityInvincible(ped, true)
FreezeEntityPosition(ped, true)

local shown = false
local inDistance = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    inDistance = false
    local coords = GetEntityCoords(PlayerPedId())


    if GetDistanceBetweenCoords(coords, pedCoords, true) < 5 then
      inDistance = true
      if IsControlJustReleased(0, 38) then
        toggleNuiFrame(true)
      end
    else
      inDistance = false
      -- Your Code Goes Here
    end

    if not shown and inDistance then
      ESX.TextUI("Press ~b~[E]~s~", "info")
      shown = true
    elseif shown and not inDistance then
      ESX.HideUI()
      shown = false
    end
  end
end)
