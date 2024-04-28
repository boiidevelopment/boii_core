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

--- Server side player functions and events.

--- @section Local functions

--- Get all players in the boii.players table.
-- @return An array of all players.
local function get_players()
    local users = {}
    for _, user in pairs(boii.players) do
        users[#users+1] = user
    end
    return users
end
exports('get_players', get_players)

--- Get a specific player object by their source.
-- @param _src number: Player's source.
-- @return The player object or nil if not found.
local function get_player(_src)
    return boii.players[_src] or nil
end
exports('get_player', get_player)

--- Get a player's identifier by source and identifier type.
-- @param _src number: Player's source.
-- @param id_type string: The type of identifier to search for.
-- @return string: The player's identifier or nil if not found.
local function get_identifier(_src, id_type)
    local identifiers = GetPlayerIdentifiers(_src)
    for _, id in pairs(identifiers) do
        if string.find(id, id_type) then
            return id
        end
    end
    return nil
end
exports('get_identifier', get_identifier)

--- Get a player's unique ID by their license.
-- @param license string: The player's license.
-- @return string: The unique ID or nil if not found.
local function get_unique_id(license)
    local query = 'SELECT unique_id FROM user_accounts WHERE license = ?'
    local params = { license }
    local result = MySQL.query.await(query, params)
    if result[1] ~= nil then
        return result[1].unique_id
    end
end
exports('get_unique_id', get_unique_id)

--- Internal help function to get player name
-- @lfunction get_player_name
local function get_player_name(_src)
    local player = get_player(_src)
    local player_name = player.data.identity.first_name .. ' ' .. player.data.identity.last_name
    return player_name
end
exports('get_player_name', get_player_name)

--- @section Events

--- Event triggered when a player joins to set their routing bucket and start status reductions.
-- @param player table: The player object.
RegisterNetEvent('boii:player_joined', function(player)
    SetPlayerRoutingBucket(player.source, 0)
    exports.boii_statuses:init(player.source)
end)

--- @section Assigning local functions

boii.get_players = get_players
boii.get_player = get_player
boii.get_identifier = get_identifier
boii.get_unique_id = get_unique_id
boii.get_player_name = get_player_name