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

--- Server side database functions.
-- @script server/database.lua

--- @section Database queries

--- @field PLAYERS_TABLE: The players table to create in database.
local PLAYERS_TABLE= [[
    CREATE TABLE IF NOT EXISTS `players` (
        `unique_id` varchar(255) NOT NULL,
        `char_id` int(1) NOT NULL DEFAULT 1,
        `passport` varchar(255) NOT NULL,
        `identity` json NOT NULL,
        `jobs` json NOT NULL,
        `gang` json NOT NULL,
        `balances` json NOT NULL,
        `inventory` json NOT NULL,
        `stats` json NOT NULL,
        `style` json NOT NULL,
        `position` varchar(255) NOT NULL,
        `last_login` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
        `created` timestamp NOT NULL DEFAULT current_timestamp(),
        PRIMARY KEY (`unique_id`, `char_id`),
        CONSTRAINT `fk_players_user_accounts` FOREIGN KEY (`unique_id`)
        REFERENCES `user_accounts` (`unique_id`) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
]]

--- Function to create sql tables on load if not created already
local function create_tables()
    debug_log('info', 'Creating players table if does not exist...')
    MySQL.update(PLAYERS_TABLE, {})
end
create_tables()