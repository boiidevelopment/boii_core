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

--- Server side player object creation.
-- @script server/player/player_object.lua

--- @section Constants

--- Maximum number of secondary jobs a player can have.
-- Each player is allowed 1 primary job and then an limited amount of secondary jobs you can limit the amount here
-- @field MAX_SECONDARY_JOBS
-- @see set_job
local MAX_SECONDARY_JOBS = config.jobs.max_secondary_jobs

--- @section Internal helper functions

--- Helper function to process data types.
-- Returns data_types if it's not empty, otherwise returns default PLAYER_DATA.DATA_TYPES.
-- @param data_types table: An array of data types to set (e.g., {'identity'}, {'balances'}).
-- @return table: The processed data types.
-- @usage
--[[
    local data_types = process_data_types(data_types)
]]
-- @see set_data, save_data
local function process_data_types(data_types)
    return next(data_types) and data_types or PLAYER_DATA.DATA_TYPES
end

--- Helper function to count the number of primary and secondary jobs.
-- @param jobs table: A table containing the player's current jobs.
-- @return number, boolean: The count of secondary jobs and a boolean indicating if a primary job exists.
local function count_jobs(self, jobs)
    local secondary_count, has_primary = 0, false
    for _, job_details in pairs(jobs) do
        if job_details.type == 'secondary' then
            secondary_count = secondary_count + 1
        elseif job_details.type == 'primary' then
            has_primary = true
        end
    end
    debug_log('info', 'Helper Function: count_jobs | Note: Secondary jobs count: ' .. secondary_count)
    return secondary_count, has_primary
end

--- Helper function to remove the player's primary job.
-- @param jobs table: A table containing the player's current jobs.
local function remove_primary_job(self, jobs)
    for job_id, job_details in pairs(jobs) do
        if job_details.type == 'primary' then
            jobs[job_id] = nil
            debug_log('info', 'Helper Function: remove_primary_job | Note: Primary job removed for player ' .. self.source)
            break
        end
    end
end

--- Helper function to update or set a player's job data.
-- @param jobs table: A table containing the player's current jobs.
-- @param new_job_id string: The identifier of the new job.
-- @param job_data table: The data of the new job.
-- @param grade_id string: The identifier of the grade within the job.
-- @see set_job
local function update_job_data(self, jobs, new_job_id, job_data, grade_id)
    if jobs[new_job_id] then
        if jobs[new_job_id].grade ~= job_data.grades[grade_id].grade then
            jobs[new_job_id].grade = job_data.grades[grade_id].grade
            debug_log('info', 'Helper Function: update_job_data | Note: Job grade updated for player ' .. self.source)
        end
    else
        jobs[new_job_id] = {
            id = job_data.id,
            type = job_data.type,
            grade = job_data.grades[grade_id].grade,
            on_duty = false
        }
        debug_log('info', 'Helper Function: update_job_data | Note: New job added for player ' .. self.source)
    end
end

--- @section Player object creation

--- Create a player object after a user selects their character.
-- Initializes a player object with default data or provided data and attaches methods to the player object.
-- Typically called after a user selects their character.
-- @param _src number: Player's source.
-- @param unique_id string: User's Unique ID.
-- @param char_id number: Character ID for the selected character.
-- @param data table: Set of data used to build the player object (optional).
-- @usage 
--[[
    local _src = source
    local player = create_player(_src, unique_id, char_id, data)
]]
local function create_player(_src, unique_id, char_id, data)
    local function creation_logic()
        if not _src or not unique_id or not char_id then
            debug_log('err', 'Missing parameters in create_player. Source: ' .. tostring(_src) .. ', Unique ID: ' .. tostring(unique_id) .. ', Char ID: ' .. tostring(char_id))
            return
        end

        debug_log('info', 'Creating player object for source: ' .. _src)

        local self = {}
        self.source = _src
        self.unique_id = unique_id
        self.char_id = char_id
        self.passport = data.passport
        self.data = data or {}

        self.data.identity = self.data.identity or PLAYER_DATA.DEFAULT_DATA.identity
        self.data.jobs = self.data.jobs or PLAYER_DATA.DEFAULT_DATA.jobs
        self.data.gang = self.data.gang or PLAYER_DATA.DEFAULT_DATA.gang
        self.data.balances = self.data.balances or PLAYER_DATA.DEFAULT_DATA.balances
        self.data.inventory = self.data.inventory or PLAYER_DATA.DEFAULT_DATA.inventory
        self.data.stats = self.data.stats or PLAYER_DATA.DEFAULT_DATA.stats
        self.data.style = self.data.style or utils.shared.style[PLAYER_DATA.DEFAULT_DATA.identity.sex]
        self.data.position = self.data.position or vector4(-268.47, -956.98, 31.22, 208.54)

        --- @section Methods

        --- Add a new method to the player object dynamically.
        -- @param method_name string: The name of the method you want to add.
        -- @param method_func function: The function that will be executed when this method is called. 
        -- @usage
        --[[
            local _src = source
            local player = boii.get_player(_src) -- Retrieve the player object
            if not player then return print('Player not found') end
            
            -- Define a new method
            local function new_method(player, param1, param2)
                -- ... (implementation of the new method)
            end

            -- Add the new method to the player object
            player.add_method('new_method_name', new_method)

            -- Now you can call the new method like any other method of the player object
            player.new_method_name(param1, param2)
        ]]
        -- @example
        --[[
            -- Let's say you want to add a method to set a player's job title
            local function set_job_title(player, job_title)
                player.data.job_title = job_title
                print('Job title set to ' .. job_title .. ' for player ' .. player.source)
            end

            player.add_method('set_job_title', set_job_title)
            player.set_job_title('Software Developer')
            -- This will set the player's job title to 'Software Developer' and print a confirmation message.
        ]]
        function self.add_method(method_name, method_func)
            self[method_name] = method_func
        end


        --- @section Balances

        --- Modify a player's balances with multiple operations.
        -- @function modify_balances
        -- @param operations table: An array of operations, each operation is a table containing balance_type, action, amount.
        -- @param reason string: The reason for modifying the balance(s) (optional).
        -- @param should_save boolean: Whether to save the updated balance(s) to the database (optional).
        -- @usage
        --[[
            local _src = source
            local player = boii.get_player(_src)
            local operations = {
                { balance_type = 'bank', action = 'remove', amount = 1000 },
                { balance_type = 'savings', action = 'add', amount = 1000 }
            }
            player.modify_balances(operations, 'Transfer from bank to savings', true)
        ]]
        function self.modify_balances(operations, reason, should_save)
            local save = should_save or false
            for _, op in ipairs(operations) do
                local balance_type = op.balance_type
                local action = op.action
                local amount = op.amount
                if balance_type == 'cash' then
                    debug_log('err', 'Cash balance type provided, diverting to modify_inventory.')
                    self.modify_inventory({{ item_id = 'cash', action = action, quantity = amount }}, reason, save)
                    return
                end
                if not self.data.balances or not self.data.balances[balance_type] then
                    debug_log('err', 'Invalid balance type provided for operation.')
                    return
                end
                local current_amount = self.data.balances[balance_type].amount or 0
                if action == 'add' then
                    current_amount += amount
                elseif action == 'remove' then
                    current_amount -= amount
                elseif action == 'set' then
                    current_amount = amount
                else
                    debug_log('err', 'Invalid action type provided for operation.')
                    return
                end
                self.data.balances[balance_type].amount = current_amount
            end
            self.set_data({ 'balances' }, save)
            debug_log('info', 'Balance modification completed for player ' .. self.source)
            if reason then
                utils.ui.notify(self.source, {
                    header = 'Balance Update',
                    message = reason,
                    type = 'info',
                    duration = 3500
                })
            end
        end

        --- @section Jobs

        --- Set a player's job.
        -- @function set_job
        -- @param new_job_id string: The identifier of the new job.
        -- @param grade_id string: The identifier of the grade within the job.
        -- @param old_job_id string (optional): The identifier of the old job to be replaced (only for secondary jobs).
        -- @return boolean: True if the job is set successfully, false otherwise.
        function self.set_job(new_job_id, grade_id, old_job_id)
            local job_data = boii.shared.get_shared_data('jobs', new_job_id)
            if not job_data then
                debug_log('err', 'Player Method: set_job | Error: The job with ID ' .. new_job_id .. ' does not exist.')
                return false
            end
            grade_id = tostring(grade_id)
            if not job_data.grades[grade_id] then
                debug_log('err', 'Player Method: set_job | Error: The grade with ID ' .. grade_id .. ' does not exist for job ' .. new_job_id)
                return false
            end
            local secondary_count, has_primary = count_jobs(self.jobs)
            if job_data.type == "primary" then
                if has_primary then
                    debug_log('info', 'Player Method: set_job | Note: Primary job replaced for player ' .. self.source)
                    remove_primary_job(self.jobs)
                end
                self.jobs[new_job_id] = nil
            elseif job_data.type == "secondary" then
                if old_job_id and self.jobs[old_job_id] then
                    self.jobs[old_job_id] = nil
                    debug_log('info', 'Player Method: set_job | Note: Secondary job ' .. old_job_id .. ' removed for player ' .. self.source)
                    secondary_count = secondary_count - 1
                end
                if not self.jobs[new_job_id] and secondary_count >= MAX_SECONDARY_JOBS then
                    debug_log('err', 'Player Method: set_job | Error: Maximum number of secondary jobs (' .. MAX_SECONDARY_JOBS .. ') reached for player ' .. self.source)
                    return false
                end
            end
            update_job_data(self, self.jobs, new_job_id, job_data, grade_id)
            debug_log('info', 'Player Method: set_job | Note: Job data updated for player ' .. self.source)
            self.set_data({'jobs'}, true)
            return true
        end

        --- @section Inventory

        --- Gets the players inventory
        -- @function get_inventory
        -- @return table: The players inventory
        function self.get_inventory()
            return self.data.inventory
        end

        --- Gets a specific item from the inventory
        -- @function get_item
        -- @param item_name: Name of the item to get.
        -- @return item | nil: Returns the specified item or nil if item is not found.
        -- @usage
        --[[
            local _src = source
            local player = boii.get_player(_src)
            local item = player.get_item('water')
            if item then
                return true
            end
        ]]
        function self.get_item(item_name)
            for _, item in pairs(self.data.inventory.items) do
                if item.id == item_name then
                    print('item: ' .. item.id .. ' quantity: ' .. item.quantity)
                    return item
                end
            end
            return nil
        end

        --- Checks if the player has an item
        -- @function has_item
        -- @param item_name: Name of the item to check.
        -- @param quantity: Amount of item required (optional).
        -- @return boolean
        -- @usage
        --[[
            local _src = source
            local player = boii.get_player(_src)
            local has_item = player.has_item(item_name, quantity)
            if has_item then
                print('Player has item')
            else
                print('Player does not have the item')
            end
        ]]
        function self.has_item(item_name, quantity)
            local required_amount = quantity or 1
            local item = self.get_item(item_name)
            return item ~= nil and item.quantity >= required_amount
        end

        --- Modify a player's inventory with multiple items.
        -- @function modify_inventory
        -- @param items table: A table of items to modify, each item should have 'item_id', 'action', and 'quantity'.
        -- @param reason string: The reason for modifying the inventory (optional).
        -- @param should_save boolean: Whether to save the updated inventory to the database (optional).
        -- @usage
        --[[
            local _src = source
            local player = boii.get_player(_src)
            local items = {
                {item_id = 'burger', action = 'add', quantity = 3},
                {item_id = 'water', action = 'remove', quantity = 1},
            }
            player.modify_inventory(items, 'Used a pawnshop.', true)
        ]]
        function self.modify_inventory(items, should_save)
            local save = should_save or false
            for _, item in ipairs(items) do
                local item_id = item.item_id
                local item_exists = exports.boii_items:find_item(item_id)
                if not item_exists then
                    debug_log('err', 'Attempted to modify inventory with invalid item ID: ' .. item_id)
                    return
                end
                local action = item.action
                local quantity = item.quantity
                local data = item.data or {}
                if not self.data.inventory.items[item_id] then
                    self.data.inventory.items[item_id] = { id = item_id, quantity = 0, data = {} }
                end
                local current_quantity = self.data.inventory.items[item_id].quantity or 0
                if action == 'add' then
                    self.data.inventory.items[item_id].quantity = current_quantity + quantity
                    self.data.inventory.items[item_id].data = data
                elseif action == 'remove' then
                    self.data.inventory.items[item_id].quantity = math.max(0, current_quantity - quantity)
                    if self.data.inventory.items[item_id].quantity <= 0 then
                        self.data.inventory.items[item_id] = nil
                    end
                else
                    debug_log('err', 'Invalid action type provided for item ' .. item_id)
                    return
                end
            end
            self.set_data({ 'inventory' }, save)
            debug_log('info', 'Inventory modification completed for player ' .. self.source)
        end
        
        --- Updates item data.
        -- @function update_item_data
        -- @param item_id string: ID of the item to update.
        -- @param updates table: Table of updates to modify.
        -- @param should_save boolean: Whether to save the updated inventory to the database (optional).
        function self.update_item_data(item_id, updates, should_save)
            local save = should_save or false
            local item = self.data.inventory.items[item_id]
            if not item then
                debug_log('err', 'Attempted to update non-existing item: ' .. item_id)
            end
            item.data = item.data or {}
            for key, value in pairs(updates) do
                item.data[key] = value
            end
            self.set_data({'inventory'}, save)
        end
        
        --- @section Setting and saving data

        --- Set a player's data within the object and sync it to the client.
        -- @function set_data
        -- @param data_types table: An array of data types to set (e.g., {'identity'}, {'balances'}). If empty, uses default PLAYER_DATA.DATA_TYPES.
        -- @param save_to_db boolean: A boolean indicating whether to save the updated data to the database (optional).
        -- @usage 
        --[[
            local _src = source
            local player = boii.get_player(_src)
            player.set_data(data_types, save_to_db)
        ]]
        -- @example
        --[[
            player.set_data({}) -- Sets all data types; you can set false here if you like however it is not required. e.g, player.set_data({}, false)
            player.set_data({ 'identity' }) -- Sets a specific data type
            player.set_data({}, true) -- Sets all data types and then saves to the database
            player.set_data({ 'identity' }, true) -- Sets a specific data type and saves to the database
        ]]
        function self.set_data(data_types, save_to_db)
            data_types = process_data_types(data_types)
            local data_table = {}
            for _, data_type in ipairs(data_types) do
                if self.data[data_type] then
                    data_table[data_type] = self.data[data_type]
                else
                    if PLAYER_DATA.DEFAULT_DATA[data_type] then
                        debug_log('info', 'Player Method: set_data | Note: Data type ' .. data_type .. ' not found in player data. Using default.')
                        data_table[data_type] = PLAYER_DATA.DEFAULT_DATA[data_type]
                    else
                        debug_log('err', 'Player Method: set_data failed. | Reason: Data type ' .. data_type .. ' not found in player data and no default available.')
                    end
                end
            end
            TriggerClientEvent('boii:cl:set_data', self.source, data_table)
            if save_to_db then
                self.save_data(data_types)
                print('Database save called for data types: ' .. json.encode(data_types))
            end
        end
        
        --- Save a player's data types to the database.
        -- This function is primarily used internally to save specified player's data types to the database.
        -- It supports saving multiple data types in a single call.
        -- @param data_types table: An array of data types to save (e.g., {'identity'}, {'balances'}).
        -- @usage 
        --[[
            local _src = source
            local player = boii.get_player(_src)
            player.save_data(data_types)
        ]]
        -- @example
        --[[
            player.save_data({}) -- Saves all player data to the database
            player.save_data({ 'identity' }) -- Saves a specific player data type to the database
        ]]
        -- @raise This function may log an error if no valid data fields are provided for saving or if the database operation fails.
        function self.save_data(data_types)
            local data_types = process_data_types(data_types)
            local params = {}
            local fields = {}
            local params_index = 1
            for _, field in ipairs(data_types) do
                if self.data[field] then
                    params[params_index] = json.encode(self.data[field])
                    fields[params_index] = field .. ' = ?'
                    params_index = params_index + 1
                end
            end
            if #fields > 0 then
                params[params_index] = self.unique_id
                params[params_index + 1] = self.char_id
                local query_fields = table.concat(fields, ', ')
                local query = 'UPDATE players SET ' .. query_fields .. ' WHERE unique_id = ? AND char_id = ?'
                MySQL.Async.execute(query, params, function(rows_changed)
                    if rows_changed > 0 then
                        debug_log('info', 'Player Method: save_data | Data saved for player. ' .. self.source)
                    else
                        debug_log('err', 'Player Method: save_data failed | Data save failed for player. ' .. self.source)
                    end
                end)
            else
                debug_log('err', 'Player Method: save_data failed | No valid data fields provided for saving.')
            end
        end

        self.set_data({}, true)

        boii.players[self.source] = self

        TriggerEvent('boii:player_joined', self)

        debug_log('info', 'Finished creating player object for source: ' .. _src)
        return self
    end

    local function creation_error_handler(err)
        debug_log('err', 'Error occurred during player creation: ' .. tostring(err))
    end

    return utils.general.try_catch(creation_logic, creation_error_handler)
end
exports('create_player', create_player)

--- @section Assign local functions

boii.create_player = create_player