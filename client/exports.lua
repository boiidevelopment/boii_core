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

--- Client side exportation of boii object.
-- @script client/exports.lua

--- @section Functions

--- Create a deep copy of a table, ensuring changes to the copy won't affect the original table.
-- This function is essential when you want to avoid unintended side effects from changes in the copied table reflecting back on the original table.
-- It recursively copies all the nested tables.
-- @function deep_copy
-- @param t table: The original table you want to copy.
-- @return table: A new table that is a deep copy of the original table.
local function deep_copy(t)
    local orig_type = type(t)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, t, nil do
            copy[deep_copy(orig_key)] = deep_copy(orig_value)
        end
        setmetatable(copy, deep_copy(getmetatable(t)))
    else
        copy = t
    end
    return copy
end

--- @section Exports

--- Exports a function to get a deep copy of the boii object.
-- This exported function allows other scripts to safely access and manipulate their own copy of the boii object without affecting the original global state.
-- This is particularly useful in multi-threaded or complex applications where maintaining isolated state is crucial.
-- @function get_object
-- @usage local boii = exports['boii_rp'].get_object()
-- @return table: A deep copy of the boii object, ensuring isolated state and no side effects on the original boii object.
exports('get_object', function() 
    return deep_copy(boii) 
end)
