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

--- Server side connections functions and events.
-- @script server/player/connections.lua

--- @section Event handlers

--- Handles the event when a player joins the server and places them into their own routing bucket.
-- @function player_joining
local function player_joining()
    local _src = source
    local bucket_count = 0
    for _ in pairs(config.routing_buckets) do
        bucket_count = bucket_count + 1
    end
    local unique_bucket_id = bucket_count + _src + 1
    SetPlayerRoutingBucket(_src, unique_bucket_id)
    SetRoutingBucketPopulationEnabled(unique_bucket_id, false)
    SetRoutingBucketEntityLockdownMode(unique_bucket_id, 'strict')
    debug_log('info', 'Player has joined with source id: ' .. _src .. ' into bucket: ' .. unique_bucket_id)
end
AddEventHandler('playerJoining', player_joining)


--- Handles the event when a player leaves (drops) from the server.
-- @function on_player_drop
-- @param reason string: The reason for the player's drop.
-- @local
local function on_player_drop(reason)
    local _src = source
    local name = GetPlayerName(_src)
    local player = boii.get_player(_src)
    local coords = GetEntityCoords(GetPlayerPed(_src))
    local heading = GetEntityHeading(GetPlayerPed(_src))
    local position = {x = coords.x, y = coords.y, z = coords.z, w = heading}
    if player then
        player.data.position = position
        player.set_data({}, true)
        Wait(100)
        boii.players[_src] = nil
    end
    debug_log('info', 'Player: '..name..' was dropped from the server! Reason: '..reason)
end
AddEventHandler('playerDropped', on_player_drop)

--- @section Events

--- Drops the player from the server
-- Used by client side nui buttons mainly
-- @see client/characters/creation.lua: disconnect button on character creation
RegisterServerEvent('boii:sv:drop_player', function()
    local _src = source
    DropPlayer(_src, 'You disconnected from the server.')
end)