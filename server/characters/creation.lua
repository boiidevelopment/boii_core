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

--- Server side character creation functions and events.
-- @script server/characters/creation.lua

--- @section Database queries

--- @field QUERY_VALIDATE_CHARACTER_NAME: Query used to validate the characters name
-- @see validate_character_name
local QUERY_VALIDATE_CHARACTER_NAME = 'SELECT 1 FROM players WHERE JSON_EXTRACT(identity, ?) = ? AND JSON_EXTRACT(identity, ?) = ?'

--- @field QUERY_GET_CHARACTERS: Query used to validate the characters name
-- @see get_character_list
local QUERY_GET_CHARACTERS = 'SELECT * FROM players WHERE unique_id = ?'

--- @field QUERY_CREATE_CHARACTER: Query used to validate the characters name
-- @see boii:sv:create_character
local QUERY_CREATE_CHARACTER = 'INSERT INTO players (unique_id, char_id, passport, identity, jobs, gang, balances, inventory, stats, style, position) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'

--- @field QUERY_SELECT_CHARACTER: Query used to select the correct character from database
local QUERY_SELECT_CHARACTER = 'SELECT * FROM players WHERE unique_id = ? AND char_id = ?'

--- @section Callbacks

--- Callback for validating a player's name.
-- Queries the database to check if the provided first and last name combination already exists.
-- Used to ensure unique names for each player character.
-- @param _src number: The player source ID (not used in this function but typically included in server-side callbacks).
-- @param data table: The data table containing 'first_name' and 'last_name' keys.
-- @param cb function: The callback function to return the result (true if name is valid and unique, false otherwise).
-- @usage 
--[[
    utils.callback.cb('boii:sv:validate_character_name', {first_name = 'John', last_name = 'Doe'}, function(is_valid)
        if is_valid then
            print('The name is valid and unique.')
        else
            print('The name already exists.')
        end
    end)
]]
-- @return boolean
-- @todo Add error handling for invalid or unexpected data inputs.
local function validate_character_name(_src, data, cb)
    local params = { '$.first_name', data.first_name, '$.last_name', data.last_name }
    MySQL.Async.fetchAll(QUERY_VALIDATE_CHARACTER_NAME, params, function(result)
        if result[1] then
            cb(false)
        else
            cb(true)
        end
    end)
end
utils.callback.register('boii:sv:validate_character_name', validate_character_name)

--- Callback to retreive character list
-- Queries database to get the players characters to enable character selection
-- @param _src number: The player source ID (not used in this function but typically included in server-side callbacks).
-- @param data table: The data table containing 'first_name' and 'last_name' keys.
-- @param cb function: The callback function to return the the players character or nil if none are found.
-- @usage
--[[
    utils.callback.cb('boii:sv:get_character_list', {}, function(has_characters)
        if has_characters then
            -- do something with characters
        else
            -- do something without characters
        end
    end)
]]
-- @return character table or nil
local function get_character_list(_src, data, cb)
    local user = utils.connections.get_user(_src)
    local unique_id = user.unique_id
    MySQL.Async.fetchAll(QUERY_GET_CHARACTERS, { unique_id }, function(results)
        if results and #results > 0 then
            local characters = {}
            for _, character in ipairs(results) do
                if character.identity then character.identity = json.decode(character.identity) end
                if character.jobs then character.jobs = json.decode(character.jobs) end
                if character.gang then character.gang = json.decode(character.gang) end
                if character.balances then character.balances = json.decode(character.balances) end
                if character.inventory then character.inventory = json.decode(character.inventory) end
                if character.stats then character.stats = json.decode(character.stats) end
                if character.style then character.style = json.decode(character.style) end
                if character.position then character.position = json.decode(character.position) end
                characters[#characters + 1] = character
            end
            cb(characters)
        else
            cb({})
        end
    end)
end
utils.callback.register('boii:sv:get_character_list', get_character_list)

--- @section Functions

-- placeholder..

--- @section Events

--- Event to create a new character
-- @param character_data table: The table of data for the character sent by the client.
RegisterServerEvent('boii:sv:create_character', function(character_data)
    if not character_data then
        debug_log('err', 'Event: boii:sv:create_character failed | Reason: Character data is missing.')
        return
    end
    local _src = source
    local user = utils.connections.get_user(_src)
    local unique_id = user.unique_id
    if not user or not unique_id then
        debug_log('err', 'Event: boii:sv:create_character failed | Reason: Missing parameters user or unique_id is missing.')
        return
    end
    local defaults = PLAYER_DATA.DEFAULT_DATA
    local passport = utils.db.generate_unique_id('B', 8, 'players', 'passport')
    local params = {
        unique_id, 
        character_data.char_id, 
        passport,
        json.encode(character_data.identity),
        json.encode(defaults.jobs),
        json.encode(defaults.gang),
        json.encode(defaults.balances),
        json.encode(defaults.inventory),
        json.encode(defaults.stats),
        json.encode(character_data.style),
        json.encode(defaults.position),
    }
    MySQL.Async.insert(QUERY_CREATE_CHARACTER, params, function(success)
        if success then
            TriggerClientEvent('boii:cl:open_character_create', _src)
        else
            debug_log('err', 'Event: boii:sv:create_character failed | Reason: MySQL failed to insert character into database.')
        end
    end)
end)

--- Event to select correct character and trigger create player
RegisterServerEvent('boii:sv:play', function(char_id)
    if not char_id then
        debug_log('err', 'Event: boii:sv:play failed | Reason: Character ID is missing.')
        return
    end
    local _src = source
    local user = utils.connections.get_user(_src)
    if not user or not user.unique_id then
        debug_log('err', 'Event: boii:sv:play failed | Reason: User not found or unique ID missing.')
        return
    end
    local unique_id = user.unique_id
    MySQL.Async.fetchAll(QUERY_SELECT_CHARACTER, {unique_id, char_id}, function(results)
        if results and #results > 0 then
            local char_data = results[1]
            char_data.passport = char_data.passport
            char_data.identity = json.decode(char_data.identity) or {}
            char_data.jobs = json.decode(char_data.jobs) or {}
            char_data.gang = json.decode(char_data.gang) or {}
            char_data.balances = json.decode(char_data.balances) or {}
            char_data.inventory = json.decode(char_data.inventory) or {}
            char_data.stats = json.decode(char_data.stats) or {}
            char_data.style = json.decode(char_data.style) or {}
            char_data.position = json.decode(char_data.position) or {}
            boii.create_player(_src, unique_id, char_id, char_data)
        else
            debug_log('err', 'Event: boii:sv:play failed | Reason: Character not found or does not belong to the user.')
        end
    end)
end)

