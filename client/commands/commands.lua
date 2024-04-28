--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|        ROLEPLAY FRAMEWORK BASE
]]

--- Client side command functions and events.
-- @script client/commands/commands.lua


--- @section General commands



--- @section Staff commands

--- Teleport to marker
RegisterNetEvent('boii:cl:tpm', function()
    local function fade_out()
        DoScreenFadeOut(650)
        while not IsScreenFadedOut() do
            Wait(0)
        end
    end
    local function fade_in()
        DoScreenFadeIn(650)
    end
    local function get_ground_z(x, y, start_z, step)
        local ground_z = 850.0
        local found = false
        for z = start_z, 0, -step do
            local altZ = (z % 2) ~= 0 and start_z - z or z
            NewLoadSceneStart(x, y, altZ, x, y, altZ, 50.0, 0)
            local current_time = GetGameTimer()
            while IsNetworkLoadingScene() and GetGameTimer() - current_time <= 1000 do
                Wait(0)
            end
            NewLoadSceneStop()
            SetPedCoordsKeepVehicle(PlayerPedId(), x, y, altZ)
            current_time = GetGameTimer()
            while not HasCollisionLoadedAroundEntity(PlayerPedId()) and GetGameTimer() - current_time <= 1000 do
                RequestCollisionAtCoord(x, y, altZ)
                Wait(0)
            end
            found, ground_z = GetGroundZFor_3dCoord(x, y, altZ, false)
            if found then
                break
            end
        end
        return found, ground_z
    end
    local blip_marker = GetFirstBlipInfoId(8)
    local start_z = 950.0
    if not DoesBlipExist(blip_marker) then
        TriggerClientEvent('chat:addMessage', {
            template = [[
                <div class="msg chat-message warning">
                    <span><i class="fa-solid fa-car-side"></i>[DEV]: You need to place a marker on the map before trying to teleport..</span>
                </div>
            ]],
            args = {}
        })
        return 'marker'
    end
    fade_out()
    local coords = GetBlipInfoIdCoord(blip_marker)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local old_coords = GetEntityCoords(PlayerPedId())
    local x, y = coords.x, coords.y
    local entity = vehicle > 0 and vehicle or PlayerPedId()
    FreezeEntityPosition(entity, true)
    local found, ground_z = get_ground_z(x, y, start_z, 25.0)
    FreezeEntityPosition(entity, false)
    fade_in()
    if not found then
        SetPedCoordsKeepVehicle(PlayerPedId(), old_coords.x, old_coords.y, old_coords.z - 1.0)
    else
        SetPedCoordsKeepVehicle(PlayerPedId(), x, y, ground_z)
    end
end)

--- Spawns a vehicle when a staff member uses /car
RegisterNetEvent('boii:cl:spawn_vehicle', function(model)
    print("Event Triggered with model: " .. model)
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    local heading = GetEntityHeading(player)
    local vehicle_hash = GetHashKey(model)
    utils.requests.model(vehicle_hash)
    local vehicle = CreateVehicle(vehicle_hash, coords.x, coords.y, coords.z, heading, true, false)
    if vehicle and DoesEntityExist(vehicle) then
        SetPedIntoVehicle(player, vehicle, -1)
        SetEntityAsNoLongerNeeded(vehicle)
        SetModelAsNoLongerNeeded(vehicle_hash)
    else
        print("Failed to create vehicle entity")
    end
end)

--- Deletes either nearest vehicle or vehicle player is inside when using /dv
RegisterNetEvent('boii:cl:delete_vehicle', function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local vehicle_data = utils.vehicles.get_vehicle_details(true)
        DeleteEntity(vehicle_data.vehicle)
    else
        local vehicle_data = utils.vehicles.get_vehicle_details(false)
        DeleteEntity(vehicle_data.vehicle)
    end
end)

--- Repairs either nearest vehicle or vehicle player is inside when using /repair
RegisterNetEvent('boii:cl:repair_vehicle', function()
    local function repair(vehicle)
        SetVehicleFuelLevel(vehicle, 100.0)
        SetVehicleOilLevel(vehicle, 1000.0)
        SetVehicleEngineHealth(vehicle, 1000.0)
        SetVehicleBodyHealth(vehicle, 1000.0)
        SetVehicleClutch(vehicle, 1000.0)
        SetVehiclePetrolTankHealth(vehicle, 1000.0)
        SetVehicleDirtLevel(vehicle, 0.1)
        SetVehicleFixed(vehicle)
    end
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local vehicle_data = utils.vehicles.get_vehicle_details(true)
        repair(vehicle_data.vehicle)
    else
        local vehicle_data = utils.vehicles.get_vehicle_details(false)
        repair(vehicle_data.vehicle)
    end
end)
