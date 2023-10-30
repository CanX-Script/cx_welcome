if Config.Framework == 'ESX' then
    ESX = nil

    ESX = exports["es_extended"]:getSharedObject()

    ESX.RegisterServerCallback('CanX:GetData', function(source, cb)
        local Users = MySQL.Sync.fetchAll('SELECT COUNT(*) FROM users', {})
        cb(Users[1]['COUNT(*)'])
    end)
    
    ESX.RegisterServerCallback('CanX:GetClaimStatus', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local result = MySQL.Sync.fetchAll("SELECT * FROM claimed WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
        if result[1] ~= nil then
            cb(false)
        else
            cb(true)
        end
    end)

    RegisterNetEvent('CanX:ClaimReward')
    AddEventHandler('CanX:ClaimReward', function(state)
        local xPlayer = ESX.GetPlayerFromId(source)
        if state == 'default' then
            local MyFuckingReward = Config.DefaultReward
            MySQL.Async.insert('INSERT INTO claimed (identifier) VALUES (@identifier)', {['@identifier'] = xPlayer.identifier}, function(rowsChanged)
                if MyFuckingReward.Type == 'cash' then
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Starter Pack Successfully Claimed!', "success")
                    xPlayer.addMoney(MyFuckingReward.Amount)
                elseif MyFuckingReward.Type == 'item' then
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Starter Pack Successfully Claimed!', "success")
                    xPlayer.addInventoryItem(MyFuckingReward.Name, MyFuckingReward.Amount)
                elseif MyFuckingReward.Type == 'vehicle' then
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Starter Pack Successfully Claimed!', "success")
                    TriggerClientEvent('CanX:ClaimVehicle', xPlayer.source, MyFuckingReward.Name)
                elseif MyFuckingReward.Type == 'weapon' then
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Starter Pack Successfully Claimed!', "success")
                    xPlayer.addWeapon(MyFuckingReward.Name, MyFuckingReward.Amount)
                end
            end)
        else
            local UsedCode = state
            local MyFuckingReward = Config.Codes[tostring(UsedCode)]
            MySQL.Async.insert('INSERT INTO claimed (identifier) VALUES (@identifier)', {['@identifier'] = xPlayer.identifier}, function(rowsChanged)
                if MyFuckingReward.Type == 'cash' then
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Starter Pack Successfully Claimed!', "success")
                    xPlayer.addMoney(MyFuckingReward.Amount)
                elseif MyFuckingReward.Type == 'item' then
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Starter Pack Successfully Claimed!', "success")
                    xPlayer.addInventoryItem(MyFuckingReward.Name, MyFuckingReward.Amount)
                elseif MyFuckingReward.Type == 'vehicle' then
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Starter Pack Successfully Claimed!', "success")
                    TriggerClientEvent('CanX:ClaimVehicle', xPlayer.source, MyFuckingReward.Name)
                elseif MyFuckingReward.Type == 'weapon' then
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Starter Pack Successfully Claimed!', "success")
                    xPlayer.addWeapon(MyFuckingReward.Name, MyFuckingReward.Ammo)
                end
            end)
        end
    end)

    ESX.RegisterServerCallback('CanX:CheckValidCode', function(source, cb, code)
        local xPlayer = ESX.GetPlayerFromId(source)
        local MyFuckingReward = Config.Codes[tostring(code)]
        if MyFuckingReward ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)

    RegisterNetEvent('CanX:SetVehicleOwner')
    AddEventHandler('CanX:SetVehicleOwner', function(vehicleProps, veh)
        local xPlayer = ESX.GetPlayerFromId(source)
        MySQL.Async.insert('INSERT INTO owned_vehicles (owner, plate, vehicle, stored, parking) VALUES (?, ?, ?, ?, ?)', {xPlayer.identifier, vehicleProps.plate, json.encode(vehicleProps), 1, 'SanAndreasAvenue'},
        function(id)
        end) 
    end)

elseif Config.Framework == 'QB' then

    QBCore = nil

    QBCore = exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateCallback('CanX:GetData', function(source, cb)
        local Users = MySQL.Sync.fetchAll('SELECT COUNT(*) FROM players', {})
        cb(Users[1]['COUNT(*)'])
    end)
    
    QBCore.Functions.CreateCallback('CanX:GetClaimStatus', function(source, cb)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        local result = MySQL.Sync.fetchAll("SELECT * FROM claimed WHERE identifier = @identifier", {['@identifier'] = xPlayer.PlayerData.citizenid})
        if result[1] ~= nil then
            cb(false)
        else
            cb(true)
        end
    end)

    RegisterNetEvent('CanX:ClaimReward')
    AddEventHandler('CanX:ClaimReward', function(state)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if state == 'default' then
            local MyFuckingReward = Config.DefaultReward
            MySQL.Async.insert('INSERT INTO claimed (identifier) VALUES (@identifier)', {['@identifier'] = xPlayer.PlayerData.citizenid}, function(rowsChanged)
                if MyFuckingReward.Type == 'cash' then
                    TriggerClientEvent('esx:showNotification', xPlayer.PlayerData.source, 'Starter Pack Successfully Claimed!', "success")
                    xPlayer.Functions.AddMoney('cash', MyFuckingReward.Amount)
                elseif MyFuckingReward.Type == 'item' then
                    TriggerClientEvent('esx:showNotification', xPlayer.PlayerData.source, 'Starter Pack Successfully Claimed!', "success")
                    xPlayer.Functions.AddItem(MyFuckingReward.Name, MyFuckingReward.Amount)
                elseif MyFuckingReward.Type == 'vehicle' then
                    TriggerClientEvent('esx:showNotification', xPlayer.PlayerData.source, 'Starter Pack Successfully Claimed!', "success")
                    TriggerClientEvent('CanX:ClaimVehicle', xPlayer.PlayerData.source, MyFuckingReward.Name)
                elseif MyFuckingReward.Type == 'weapon' then
                    TriggerClientEvent('esx:showNotification', xPlayer.PlayerData.source, 'Starter Pack Successfully Claimed!', "success")
                    xPlayer.Functions.AddItem(MyFuckingReward.Name, 1)
                end
            end)
        else
            local UsedCode = state
            local MyFuckingReward = Config.Codes[tostring(UsedCode)]
            MySQL.Async.insert('INSERT INTO claimed (identifier) VALUES (@identifier)', {['@identifier'] = xPlayer.PlayerData.citizenid}, function(rowsChanged)
                if MyFuckingReward.Type == 'cash' then
                    TriggerClientEvent('esx:showNotification', xPlayer.PlayerData.source, 'Starter Pack Successfully Claimed!', "success")
                    xPlayer.Functions.AddMoney('cash', MyFuckingReward.Amount)
                elseif MyFuckingReward.Type == 'item' then
                    TriggerClientEvent('esx:showNotification', xPlayer.PlayerData.source, 'Starter Pack Successfully Claimed!', "success")
                    xPlayer.Functions.AddItem(MyFuckingReward.Name, MyFuckingReward.Amount)
                elseif MyFuckingReward.Type == 'vehicle' then
                    TriggerClientEvent('esx:showNotification', xPlayer.PlayerData.source, 'Starter Pack Successfully Claimed!', "success")
                    TriggerClientEvent('CanX:ClaimVehicle', xPlayer.PlayerData.source, MyFuckingReward.Name)
                elseif MyFuckingReward.Type == 'weapon' then
                    TriggerClientEvent('esx:showNotification', xPlayer.PlayerData.source, 'Starter Pack Successfully Claimed!', "success")
                    xPlayer.Functions.AddItem(MyFuckingReward.Name, 1)
                end
            end)
        end
    end)

    QBCore.Functions.CreateCallback('CanX:CheckValidCode', function(source, cb, code)
        local MyFuckingReward = Config.Codes[tostring(code)]
        if MyFuckingReward ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)

    RegisterNetEvent('CanX:SetVehicleOwner')
    AddEventHandler('CanX:SetVehicleOwner', function(vehicleProps, veh)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {xPlayer.PlayerData.license, xPlayer.PlayerData.citizenid, veh, vehicleProps.model, json.encode(vehicleProps), vehicleProps.plate, 'pillboxgarage', 1},
        function(id)
        end)
    end)

end
