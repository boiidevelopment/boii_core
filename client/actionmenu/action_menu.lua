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

--- @section Variables

--- Track blip states to toggle on/off.
local blip_states = {
    general_store = true,
    ammunation = true,
    bank = true
}

--- Tracks state of all blips to toggle on/off.
local blips_enabled = true

--- Tracks window states.
local window_states = {false, false, false, false}

--- @section Action menu

--- Action menu used within the base.
-- F2 to open by default.
local menu = {
    {
        label = 'Map Utilities',
        icon = 'fa-solid fa-map',
        submenu = {
            {
                label = 'Blips',
                icon = 'fa-solid fa-map-marker-alt',
                submenu = {
                    {
                        label = 'Toggle All Blips',
                        icon = 'fa-solid fa-map-marker-alt',
                        action_type = 'client',
                        action = 'boii:cl:toggle_blips',
                        params = { category = 'all' }
                    },
                    {
                        label = 'Toggle 24/7 Blips',
                        icon = 'fa-solid fa-store',
                        action_type = 'client',
                        action = 'boii:cl:toggle_blips',
                        params = { category = 'general_store' }
                    },
                    {
                        label = 'Toggle Ammunation Blips',
                        icon = 'fa-solid fa-person-rifle',
                        action_type = 'client',
                        action = 'boii:cl:toggle_blips',
                        params = { category = 'ammunation' }
                    },
                    {
                        label = 'Toggle Bank Blips',
                        icon = 'fa-solid fa-building-columns',
                        action_type = 'client',
                        action = 'boii:cl:toggle_blips',
                        params = { category = 'bank' }
                    }
                }
            },
            {
                label = 'GPS',
                icon = 'fa-solid fa-location-arrow',
                submenu = {
                    {
                        label = 'Locate Nearest 24/7',
                        icon = 'fa-solid fa-bullseye',
                        action_type = 'client',
                        action = 'boii:cl:locate_closest_blip',
                        params = { category = 'general_store' }
                    },
                    {
                        label = 'Locate Nearest Ammunation',
                        icon = 'fa-solid fa-bullseye',
                        action_type = 'client',
                        action = 'boii:cl:locate_closest_blip',
                        params = { category = 'ammunation' }
                    },
                    {
                        label = 'Locate Nearest Bank',
                        icon = 'fa-solid fa-bullseye',
                        action_type = 'client',
                        action = 'boii:cl:locate_closest_blip',
                        params = { category = 'bank' }
                    },
                }
            }
        }
    },
    {
        label = 'Vehicle Utilities',
        icon = 'fa-solid fa-car',
        submenu = {
            {
                label = 'Doors',
                icon = 'fa-solid fa-car-side',
                submenu = {
                    {
                        label = 'Toggle All Doors',
                        icon = 'fa-solid fa-door-open',
                        action_type = 'client',
                        action = 'boii:cl:toggle_vehicle_doors',
                        params = { door_index = 'all' }
                    },
                    {
                        label = 'Toggle Driver\'s Door',
                        icon = 'fa-solid fa-door-open',
                        action_type = 'client',
                        action = 'boii:cl:toggle_vehicle_doors',
                        params = { door_index = 0 }
                    },
                    {
                        label = 'Toggle Passenger\'s Door',
                        icon = 'fa-solid fa-door-open',
                        action_type = 'client',
                        action = 'boii:cl:toggle_vehicle_doors',
                        params = { door_index = 1 }
                    },
                    {
                        label = 'Toggle Left Rear Door',
                        icon = 'fa-solid fa-door-open',
                        action_type = 'client',
                        action = 'boii:cl:toggle_vehicle_doors',
                        params = { door_index = 2 }
                    },
                    {
                        label = 'Toggle Right Rear Door',
                        icon = 'fa-solid fa-door-open',
                        action_type = 'client',
                        action = 'boii:cl:toggle_vehicle_doors',
                        params = { door_index = 3 }
                    },
                    {
                        label = 'Toggle Hood',
                        icon = 'fa-solid fa-car',
                        action_type = 'client',
                        action = 'boii:cl:toggle_vehicle_doors',
                        params = { door_index = 4 }
                    },
                    {
                        label = 'Toggle Trunk',
                        icon = 'fa-solid fa-car',
                        action_type = 'client',
                        action = 'boii:cl:toggle_vehicle_doors',
                        params = { door_index = 5 }
                    }
                }
            },
            {
                label = 'Windows',
                icon = 'fa-solid fa-window-maximize',
                submenu = {
                    {
                        label = 'Toggle All Windows',
                        icon = 'fa-solid fa-window-restore',
                        action_type = 'client',
                        action = 'boii:cl:toggle_vehicle_windows',
                        params = { window_index = 'all' }
                    },
                    {
                        label = 'Toggle Front Left Window',
                        icon = 'fa-solid fa-window-minimize',
                        action_type = 'client',
                        action = 'boii:cl:toggle_vehicle_windows',
                        params = { window_index = 0 }
                    },
                    {
                        label = 'Toggle Front Right Window',
                        icon = 'fa-solid fa-window-minimize',
                        action_type = 'client',
                        action = 'boii:cl:toggle_vehicle_windows',
                        params = { window_index = 1 }
                    },
                    {
                        label = 'Toggle Rear Left Window',
                        icon = 'fa-solid fa-window-minimize',
                        action_type = 'client',
                        action = 'boii:cl:toggle_vehicle_windows',
                        params = { window_index = 2 }
                    },
                    {
                        label = 'Toggle Rear Right Window',
                        icon = 'fa-solid fa-window-minimize',
                        action_type = 'client',
                        action = 'boii:cl:toggle_vehicle_windows',
                        params = { window_index = 3 }
                    }
                }
            },
            {
                label = 'Engine',
                icon = 'fa-solid fa-gear',
                submenu = {
                    {
                        label = 'Turn Engine On',
                        icon = 'fa-solid fa-car-on',
                        action_type = 'client',
                        action = 'boii:cl:toggle_vehicle_engine',
                        params = { state = true }
                    },
                    {
                        label = 'Turn Engine Off',
                        icon = 'fa-solid fa-car',
                        action_type = 'client',
                        action = 'boii:cl:toggle_vehicle_engine',
                        params = { state = false }
                    }
                }
            }
        }
    },
    {
        label = 'Personal',
        icon = 'fa-solid fa-user',
        submenu = {
            {
                label = 'Check Server ID',
                icon = 'fa-solid fa-id-badge',
                action_type = 'client',
                action = 'boii:cl:check_server_id',
                params = {}
            }
        }
    },
    {
        label = 'Finances',
        icon = 'fa-solid fa-building-columns',
        submenu = {
            {
                label = 'Check Bank Balance',
                icon = 'fa-solid fa-wallet',
                action_type = 'client',
                action = 'boii:cl:check_balance',
                params = {
                    balance_type = 'bank'
                }
            },
            {
                label = 'Check Savings Balance',
                icon = 'fa-solid fa-wallet',
                action_type = 'client',
                action = 'boii:cl:check_balance',
                params = {
                    balance_type = 'savings'
                }
            }
        }
    }
}

--- @section Local functions

--- Toggle engine state
-- @param state: State of the engine.
local function toggle_engine(state)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle and DoesEntityExist(vehicle) then
        SetVehicleEngineOn(vehicle, state, false, true)
        TriggerEvent('boii_hud:cl:update_engine_icon', 'engine_state', state)
    end
end

--- Toggle vehicle doors
-- @param vehicle: The vehicle to toggle doors for.
-- @param door_index: The door to toggle.
local function toggle_door(vehicle, door_index)
    if door_index == 'all' then
        local open_any = false
        for i = 0, 5 do
            if GetVehicleDoorAngleRatio(vehicle, i) > 0.0 then
                open_any = true
                break
            end
        end
        for i = 0, 5 do
            if open_any then
                SetVehicleDoorShut(vehicle, i, false)
            else
                SetVehicleDoorOpen(vehicle, i, false, false)
            end
        end
    else
        if GetVehicleDoorAngleRatio(vehicle, door_index) > 0.0 then
            SetVehicleDoorShut(vehicle, door_index, false)
        else
            SetVehicleDoorOpen(vehicle, door_index, false, false)
        end
    end
end

--- Function to check server ID and possibly display it.
local function check_server_id()
    local id = GetPlayerServerId(PlayerId())
    utils.ui.notify({
        type = 'info',
        header = 'INFORMATION',
        message = 'Your state ID is: {'.. id ..'}',
        duration = 4500
    })
end

--- @section Events

--- Event to trigger toggle engine function
-- @param data: Params table received from menu.
RegisterNetEvent('boii:cl:toggle_vehicle_engine', function(data)
    toggle_engine(data.state)
end)

--- Event to trigger toggle door function on closest vehicle
-- @param data: Params table received from menu.
RegisterNetEvent('boii:cl:toggle_vehicle_doors', function(data)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        vehicle_data = utils.vehicles.get_vehicle_details(true)
    else
        vehicle_data = utils.vehicles.get_vehicle_details(false)
    end
    toggle_door(vehicle_data.vehicle, data.door_index)
end)

--- Function to toggle vehicle window
-- @param vehicle: The vehicle to toggle windows for.
-- @param window_index: The window to toggle or 'all' for all windows.
local function toggle_window(vehicle, window_index)
    if window_index == 'all' then
        local anyWindowDown = false
        for i = 0, 3 do
            if window_states[i+1] then
                anyWindowDown = true
                break
            end
        end
        for i = 0, 3 do
            if anyWindowDown then
                RollUpWindow(vehicle, i)
                window_states[i+1] = false
            else
                RollDownWindow(vehicle, i)
                window_states[i+1] = true
            end
        end
    else
        if window_states[window_index + 1] then
            RollUpWindow(vehicle, window_index)
            window_states[window_index + 1] = false
        else
            RollDownWindow(vehicle, window_index)
            window_states[window_index + 1] = true
        end
    end
end

--- Event to trigger toggle window function
-- @param data: Params table received from menu.
RegisterNetEvent('boii:cl:toggle_vehicle_windows', function(data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle and DoesEntityExist(vehicle) then
        toggle_window(vehicle, data.window_index)
    end
end)

--- Toggle blips based on the menu interaction
-- @param data: Params table received from menu.
RegisterNetEvent('boii:cl:toggle_blips', function(data)
    local category = data.category
    if category == 'all' then
        blips_enabled = not blips_enabled
        utils.blips.toggle_all_blips(blips_enabled)
    else
        blip_states[category] = not blip_states[category]
        utils.blips.toggle_blips_by_category(category, blip_states[category])
    end
end)

--- Event to run check id function.
-- @see check_server_id
RegisterNetEvent('boii:cl:check_server_id', function()
    check_server_id()
end)

--- Event to check balance by type.
-- @param data: Params table received from menu.
RegisterNetEvent('boii:cl:check_balance', function(data)
    local finance_data = boii.get_data('balances')
    if finance_data and finance_data[data.balance_type] then
        local balances = finance_data[data.balance_type]
        local message = string.format("Your %s balance is: $%s\nInterest Rate: %.2f%%\nAccrued Interest: $%s", data.balance_type, balances.amount, balances.interest_rate * 100, balances.interest_accrued)
        utils.ui.notify({
            type = 'info',
            header = 'FINANCES',
            message = message,
            duration = 4500
        })
    else
        utils.ui.notify({
            type = 'error',
            header = 'FINANCES',
            message = 'Unable to retrieve finance data.',
            duration = 4500
        })
    end
end)

--- Event to locate the closest blip by category.
-- @param data: Params table received from menu.
RegisterNetEvent('boii:cl:locate_closest_blip', function(data)
    local category = data.category
    local blips = utils.blips.get_blips_by_category(category)
    local closest_blip = nil
    local min_dist = math.huge
    local p_coords = GetEntityCoords(PlayerPedId())
    for _, blip in ipairs(blips) do
        local b_coords = GetBlipCoords(blip)
        local dist = #(p_coords - b_coords)
        if dist < min_dist then
            closest_blip = blip
            min_dist = dist
        end
    end
    if closest_blip then
        SetNewWaypoint(GetBlipCoords(closest_blip).x, GetBlipCoords(closest_blip).y)
        utils.ui.notify({
            type = 'success',
            header = 'GPS',
            message = 'Waypoint has been set to the nearest ' .. category .. '.',
            duration = 4500
        })
    else
        utils.ui.notify({
            type = 'error',
            header = 'GPS Error',
            message = 'No nearby ' .. category .. ' found.',
            duration = 4500
        })
    end
end)

--- @section Keymapping

RegisterCommand('open_action_menu', function()
    exports.boii_ui:action_menu(menu)
end, false)
RegisterKeyMapping('open_action_menu', 'Open Action Menu', 'keyboard', 'F2')
