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

--- Server side command list.
-- @script server/commands/commands.lua

--- @section Global commands

--- Displays the players current server id.
utils.commands.register('id', nil, 'Display your current server id.', {}, function(source, args, raw)
    utils.ui.notify(source, {
        type = 'info',
        header = 'SERVER ID',
        message = 'Your current server ID is: '.. source,
        duration = 3500
    })
end)

--- Logout and return to character select
utils.commands.register('logout', nil, 'Return to character select.', {}, function(source, args, raw)
    local player_name = boii.get_player_name(source)
    TriggerClientEvent('chat:addMessage', source, {
        template = [[
            <div class="msg chat-message success">
                <span><i class="fa-solid fa-car-side"></i>[SYSTEM]: Logging out of {0}!</span>
            </div>
        ]],
        args = { player_name }
    })
    Wait(1000)
    TriggerClientEvent('boii:cl:open_character_create', source)
end)

--- @section Staff commands

--- Teleport to marker
utils.commands.register('tpm', { 'dev' }, 'Teleport to a set marker.', {}, function(source, args, raw)
    TriggerClientEvent('chat:addMessage', source, {
        template = [[
            <div class="msg chat-message success">
                <span><i class="fa-solid fa-car-side"></i>[SYSTEM]: Teleporting to a marker!</span>
            </div>
        ]],
        args = {}
    })
    TriggerClientEvent('boii:cl:tpm', source)
end)

--- Spawn a vehicle
-- If no vehicle model is specified then an adder will spawn as default.
utils.commands.register('car', { 'dev' }, 'Spawn a vehicle.', {{ name = 'vehicle', help = 'Name of vehicle to spawn, if no name is provided adder will spawn.' }}, function(source, args, raw)
    local model = args[1] or "adder"
    TriggerClientEvent('chat:addMessage', source, {
        template = [[
            <div class="msg chat-message success">
                <span><i class="fa-solid fa-car-side"></i>[SYSTEM]: Spawning a vehicle!</span>
            </div>
        ]],
        args = {}
    })
    TriggerClientEvent('boii:cl:spawn_vehicle', source, model)
end)

--- Delete vehicle
-- If a player is in a vehicle this will delete the vehicle they are inside.
-- Otherwise delete the closest vehicle.
utils.commands.register('dv', { 'dev' }, 'Delete the nearest vehicle or vehicle you are inside.', {}, function(source, args, raw)
    TriggerClientEvent('chat:addMessage', source, {
        template = [[
            <div class="msg chat-message success">
                <span><i class="fa-solid fa-car-side"></i>[SYSTEM]: Deleting a vehicle!</span>
            </div>
        ]],
        args = {}
    })
    TriggerClientEvent('boii:cl:delete_vehicle', source)
end)

--- Repair vehicle
-- If a player is in a vehicle this will repair the vehicle they are inside.
-- Otherwise repair the closest vehicle.
utils.commands.register('repair', { 'dev' }, 'Repair the nearest vehicle or vehicle you are inside.', {}, function(source, args, raw)
    TriggerClientEvent('chat:addMessage', source, {
        template = [[
            <div class="msg chat-message success">
                <span><i class="fa-solid fa-car-side"></i>[SYSTEM]: Repairing a vehicle!</span>
            </div>
        ]],
        args = {}
    })
    TriggerClientEvent('boii:cl:repair_vehicle', source)
end)

--- Revive a player
-- Provide an ID to revive any player in the server.
-- If no ID is provided this will revive self.
utils.commands.register('revive', { 'dev' }, 'Revive a player player.', {{ name = 'id', help = 'Target id to revive.' }}, function(source, args, raw)
    local target = tonumber(args[1])
    local player = exports.boii_statuses:get_player(target)
    TriggerClientEvent('chat:addMessage', target, {
        template = [[
            <div class="msg chat-message success">
                <span><i class="fa-solid fa-car-side"></i>[SYSTEM]: You have been revived!</span>
            </div>
        ]],
        args = {}
    })
    player.revive_player()
end)

--- Adjust a players balances
utils.commands.register('adjust_balance', { 'dev' }, 'Adjust a players balance.', {{ name = 'id', help = 'Target id to adjust balance for.' }, { name = 'balance_type', help = 'bank | savings | cash' }, { name = 'action', help = 'add | remove | set' }, { name = 'amount', help = 'The amount to adjust.' }}, function(source, args, raw)
    local target = tonumber(args[1])
    local balance = tostring(args[2])
    local action = tostring(args[3])
    local amount = tonumber(args[4])
    if not target or not balance or not action or not amount then
        print('Usage: /set_job <id> <balance> <action> <amount>')
        return
    end
    local player = boii.get_player(target)
    if player then
        utils.fw.adjust_balance(target, {
            operations = {{ balance_type = balance, action = action, amount = amount }}, 
            reason = 'Staff command: Adjust balance.', 
            should_save = true
        })
    end
end)

--- Sets a players job
utils.commands.register('set_job', { 'dev' }, 'Set a players job.', {{ name = 'id', help = 'Target id to set job.' }, { name = 'job_id', help = 'Job name: police | ems | farmer | etc.' }, { name = 'grade', help = 'Id for the grade: 1 | 2 | 3 | etc.' }, { name = 'old_job', help = 'Optional, used to replace a secondary job.' }}, function(source, args, raw)
    local target = tonumber(args[1])
    local job_id = tostring(args[2])
    local grade_id = tostring(args[3]) or '1'
    local old_job_id = tostring(args[4]) or nil
    if not target or not job_id or not grade_id then
        print('Usage: /set_job <id> <job_id> <grade_id> [old_job_id]')
        return
    end
    local player = boii.get_player(source)
    if player then
        local success = player.set_job(job_id, grade_id, old_job_id)
        if success then
            TriggerClientEvent('chat:addMessage', target, {
                template = [[
                    <div class="msg chat-message success">
                        <span><i class="fa-solid fa-briefcase"></i>[SYSTEM]: Your job has been changed!</span>
                    </div>
                ]],
                args = {}
            })
        else
            TriggerClientEvent('chat:addMessage', target, {
                template = [[
                    <div class="msg chat-message error">
                        <span><i class="fa-solid fa-briefcase"></i>[SYSTEM]: Failed to set job!</span>
                    </div>
                ]],
                args = {}
            })
        end
    else
        print('Player was not found.')
    end
end)