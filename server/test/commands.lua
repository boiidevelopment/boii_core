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

--- Server side testing.
-- @script server/test/commands.lua

--- Function to print the player's identity data.
-- Retrieves and prints the identity data of the player for debugging purposes.
-- @function print_identity
-- @param _src number: the source ID of the player
local function print_identity(_src)
    local player = boii.get_player(_src)
    if player and player.data.identity then
        for k, v in pairs(player.data.identity) do
            print(k .. ': ' .. v)
        end
    else
        print("Player or identity data not found for source: " .. _src)
    end
end

-- Register a command that allows printing the player's identity data in the console.
RegisterCommand('server:print_identity', function(source, args, raw)
    print_identity(source)
end)

--- Function to print the player's balance data.
-- Retrieves and prints the balance data of the player for debugging purposes.
-- @function print_balances
-- @param _src number: the source ID of the player
local function print_balances(_src)
    local player = boii.get_player(_src)
    if player and player.data.balances then
        utils.tables.print_table(player.data.balances)
    else
        print("Player or balances data not found for source: " .. _src)
    end
end

-- Register a command that allows printing the player's balance data in the console.
RegisterCommand('server:print_balances', function(source, args, raw)
    print_balances(source)
end)

--- Function to simulate player load for testing server load of status reductions.
-- Creates a specified number of mock players and starts status reductions for testing.
-- @function sim_player_load
-- @param source number: the source ID of the command invoker
-- @param args table: command arguments (expected: number of players to simulate)
local function sim_player_load(source, args)
    if source ~= 0 then
        debug_log('err', 'This command can only be run from the server console or by an authorized admin.')
        return
    end
    local player_nums = tonumber(args[1]) or 100
    debug_log('info', 'Starting simulation of ' .. player_nums .. ' players.')
    CreateThread(function()
        for i = 1, player_nums do
            local mock_src = "mock_" .. i 
            local mock_uid = "uid_" .. i
            local mock_char = i 
            boii.create_player(mock_src, mock_uid, mock_char, nil)
            Wait(50)
        end
        for _, player in pairs(boii.players) do
            start_status_reductions(player)
        end
        debug_log('info', player_nums .. ' simulated players created and status reduction initiated.')
    end)
end

-- Register a command that allows simulating player load.
RegisterCommand('server:sim_player_load', sim_player_load)

--- Function to copy coordinates.
-- Copies the player's current coordinates to the clipboard in a specified format.
-- @function copy_coords
-- @param source number: the source ID of the command invoker
-- @param args table: command arguments (expected: vector format type)
local function copy_coords(source, args)
    local type = args[1] or 'v4'
    TriggerClientEvent('boii:cl:copy_coords', source, type)
end

-- Register a command that allows copying the player's coordinates in the specified vector format.
RegisterCommand('copy_coords', copy_coords)

-- Register a test command '/testchangejob'
RegisterCommand('testchangejob', function(source, args, rawCommand)
    local new_job_id = args[1]
    local grade_id = args[2]
    local old_job_id = args[3]
    if not new_job_id or not grade_id then
        print('Usage: /testchangejob <new_job_id> <grade_id> [old_job_id]')
        return
    end
    local player = boii.get_player(source)
    if player then
        local success = player.set_job(new_job_id, grade_id, old_job_id)
        if success then
            print('Job set successfully for player ' .. source)
        else
            print('Failed to set job for player ' .. source)
        end
    else
        print('Player not found for server ID ' .. source)
    end
end, false)

RegisterCommand('test_modify_inventory', function(source, args, rawCommand)
    local player = boii.get_player(source)
    if player then
        local items = {
            {item_id = 'old_cheese', action = 'add', quantity = 20},
            {item_id = 'old_bread', action = 'add', quantity = 20}
        }
        utils.fw.adjust_inventory(source, {
            items = items, 
            note = 'Test add items command', 
            should_save = true
        })
    end
end, false)

RegisterCommand('test_modify_balances', function(source, args, rawCommand)
    local player = boii.get_player(source)
    if player then
        print('Balances before modification - Bank: ' .. player.balances.bank.amount .. ' Savings: ' .. player.balances.savings.amount)
        local operations = {
            {balance_type = 'bank', action = 'remove', amount = 1000},
            {balance_type = 'savings', action = 'add', amount = 1000}
        }
        local validation_data = { location = vector3(100.0, 100.0, 20.0), distance = 10.0, drop_player = true }
        utils.fw.adjust_balance(_src, {
            operations = operations, 
            validation_data = validation_data, 
            reason = 'Transfer from bank to savings', 
            should_save = true
        })
        print('Balances after modification - Bank: ' .. player.balances.bank.amount .. ' Savings: ' .. player.balances.savings.amount)
    end
end, false)

--- Function to simulate balance modification load for testing server performance.
-- Creates a specified number of mock players and performs balance modifications.
-- @function sim_balance_load
-- @param source number: the source ID of the command invoker
-- @param args table: command arguments (expected: number of players to simulate)
local function sim_balance_load(source, args)
    if source ~= 0 then
        debug_log('err', 'This command can only be run from the server console or by an authorized admin.')
        return
    end
    local player_nums = tonumber(args[1]) or 100
    local start_time = os.clock()
    print('Starting simulation of balance modifications for ' .. player_nums .. ' players.')
    CreateThread(function()
        for i = 1, player_nums do
            local mock_src = "mock_" .. i 
            local mock_uid = "uid_" .. i
            local mock_char = i 
            boii.create_player(mock_src, mock_uid, mock_char, nil)
            Wait(50)
        end
        for _, player in pairs(boii.players) do
            local operations = {
                { balance_type = 'bank', action = 'add', amount = 1000 }
            }
            player.modify_balances(operations, 'Simulated deposit', false)
        end
        local end_time = os.clock()
        local elapsed_time = end_time - start_time
        print(player_nums .. ' balance modifications completed in ' .. elapsed_time .. ' seconds.')
    end)
end
RegisterCommand("sim_balance_load", sim_balance_load) 
