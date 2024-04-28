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

--- Server side configuration setup.
-- @script server/config.lua

--- @field config table: The main table holding all the data related to framework server side configuration.
config = config or {}

--- @section General settings

--- Debug toggle
-- @field debug boolean: Used to enable / disable the use of server side debug prints
config.debug = true

--- Routing bucket settings
-- @field id: The id for the routing bucket
-- @field label: Human readable label for the bucket
-- @field bucket: The routing bucket number to place players into
-- @field mode: The routing bucket mode: 'strict' -- No entities can be created by clients at all | 'relaxed' -- Only script-owned entities created by clients are blocked | 'inactive' -- Clients can create any entity they want
-- @field population_enabled: true | false
-- @field locations:
-- @field spawn: Default spawn location for new players
-- @field staff_only: 
-- @field enabled: true | false
-- @field ranks: Any ranks here can join the staff only bucket if enabled
-- @field vip_only:
-- @field enabled: true | false
-- @field level: Vip level required to enter the bucket if enabled
-- @field restrict_world_size:
-- @field enabled: true | false
-- @field players: The amount of players that can join the bucket if enabled     
config.routing_buckets = {
    main_world = { 
        id = 'main_world',
        label = 'Roleplay World',
        bucket = 0,
        mode = 'relaxed',
        population_enabled = true,
        locations = {
            spawn = vector4(-268.47, -956.98, 31.22, 208.54)
        },
        staff_only = {
            enabled = false,
            ranks = { }
        },
        vip_only = {
            enabled = false,
            level = 0, 
        },
        restrict_world_size = {
            enabled = false,
            players = 42
        }
    },
    staff_world = {
        id = 'staff_world',
        label = 'Staff Only World', 
        bucket = 1,
        mode = 'relaxed',
        population_enabled = true,
        locations = {
            spawn = vector4(-268.47, -956.98, 31.22, 208.54)
        },
        staff_only = {
            enabled = true,
            ranks = { 'dev' }
        },
        vip_only = {
            enabled = false,
            level = 0, 
        },
        restrict_world_size = {
            enabled = true,
            players = 1
        }
    }
}

--- @section Player jobs

--- Jobs table
-- @field max_secondary_jobs: Amount of secondary jobs players are limited to. -- Players have 1 primary then however many secondary you like.
config.jobs = {
    max_secondary_jobs = 2,
}