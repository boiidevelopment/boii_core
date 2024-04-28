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

--- Shared initialization.
-- @script shared/init.lua

--- @section Shared Initialization
-- This section contains shared functions and configurations for use throughout the server.

-- Import utility library from 'boii_utils' resource.
utils = exports.boii_utils:get_utils()

shared = shared or {}

--- @section Local functions

--- Retrieve data from the shared tables based on category and request_data
-- @param category string: the category to search within ('gangs', 'jobs', 'vehicles', etc.)
-- @param request_data string: the specific data to retrieve within the category
-- @return table|nil: the retrieved data if found, or nil if not found
-- @usage 
--[[
    local data = boii.shared.get_shared_data(category, request_data)
]]
-- @example
--[[
    local ballas_data = boii.shared.get_shared_data("gangs", "ballas")
    if ballas_data then
        -- Do something with ballas_data
    end
]]
local function get_shared_data(category, request_data)
    if not category or not request_data then
        debug_log('err', 'Function: get_shared_data failed | Reason: Missing one or more required parameters. - category or request_data.') 
        return nil
    end
    if not shared[category] then
        debug_log('err', 'Function: get_shared_data failed | Reason: Category ' .. category .. ' not found in shared data.') 
        return nil
    end
    for id, shared_data in pairs(shared[category]) do
        if id == request_data then
            return shared_data
        end
    end
    debug_log('err', 'Function: get_shared_data failed | Reason: Data for request ' .. request_data .. ' not found in category ' .. category .. '.') 
    return nil
end
exports('get_shared_data', get_shared_data)

--- @section Global functions

--- Function to handle debug logging.
-- @function debug_log
-- @param type string: The type of log (e.g., 'info', 'err'). Determines how the log is processed and where it's displayed.
-- @param message string: The actual log message to be recorded.
function debug_log(type, message)
    if config.debug then
        utils.debug[type](message)
    end
end

--- @section Assign local functions

shared.get_shared_data = get_shared_data