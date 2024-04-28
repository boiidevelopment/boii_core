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

--- Client side player functions and events
-- @script client/player/player.lua

--- @section Local functions

--- Get character data.
-- @param key string: The key for the specific data to retrieve (optional).
-- @usage
--[[
    -- Gets a specific section of player data
    local health = get_data('statuses').health

    -- Gets all player data
    local all_data = get_data()
]]
local function get_data(key)
    if key then
        return boii.player_data[key]
    else
        return boii.player_data
    end
end
exports('get_data', get_data)

--- Set character data.
-- @param data_table table: A table containing the character data to be set.
-- @usage set_data({ 'identity', 'genetics' })
local function set_data(data_table)
    for key, value in pairs(data_table) do
        boii.player_data[key] = value
    end
end

--- @section Events

--- Event to set character data.
-- @param data table: A table containing the character data to be set.
-- @usage 
--[[
    -- Used internally to sync data exposed by player object to client
    TriggerClientEvent('boii:cl:set_data', self.source, data)
]]
-- @see set_data
RegisterNetEvent('boii:cl:set_data', function(data)
    if not data then 
        debug_log('err', 'Event: boii:cl:set_data failed. | Reason: Data is missing.')
    end
    set_data(data)
end)

--- Event to initialise hud.
-- Currently only setup for boii_hud however should be easily replacable for any, most will follow a similar format :) 
RegisterNetEvent('boii:cl:init_hud', function()
    while GetResourceState('boii_hud') ~= 'started' do
        Wait(500)
    end
    exports.boii_hud:init()
end)

--- @section Assign local functions

boii.get_data = get_data
