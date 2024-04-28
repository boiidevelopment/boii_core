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

--- Client side inventory functions and events.
-- @script client/inventory/inventory.lua

--- @section Variables 

--- @field inventory_open: Flag to indicate whether inventory is open already or not.
local inventory_open = false

--- @field current_weapon: Variable to store the players current equiped weapon.
local current_weapon = nil

--- @section Local functions

--- Opens the players inventory
-- @todo Replace with an actual UI instead of using menu based system.
local function open_inventory()
    if inventory_open then
        utils.ui.notify({
            type = 'error',
            header = 'INVETORY',
            message = 'Inventory is already open.',
            duration = 4500
        })
        return
    end
    local identity = boii.get_data('identity')
    local inventory = boii.get_data('inventory')
    if not identity or not inventory then
        utils.ui.notify({
            type = 'error',
            header = 'INVETORY',
            message = 'Cannot open inventory, player identity or inventory data missing.',
            duration = 4500
        })
        return
    end
    local context_menu_options = {}
    local total_item_weight = 0
    local used_slots = 0
    if next(inventory.items) ~= nil then
        for item_id, item_data in pairs(inventory.items) do
            local item = exports.boii_items:find_item(item_id)
            if item then
                total_item_weight += (item.weight * item_data.quantity)
                used_slots += 1
                local item_messages = {
                    'Weight: ' .. item.weight * item_data.quantity .. 'g',
                    'Quantity: ' .. item_data.quantity,
                    'Description: ' .. item.description
                }
                if item_data.data then
                    for key, value in pairs(item_data.data) do
                        local formatted_key = key:gsub("^%l", string.upper)
                        if type(value) == 'table' then
                            if key == "attachments" then
                                local attachment_list = {}
                                for attachment_id, attached in pairs(value) do
                                    if attached then
                                        local attachment_item = exports.boii_items:find_item(attachment_id)
                                        if attachment_item then
                                            attachment_list[#attachment_list + 1] = attachment_item.label
                                        end
                                    end
                                end
                                value = table.concat(attachment_list, ", ")
                            else
                                value = table.concat(value, ", ")
                            end
                        end
                        item_messages[#item_messages + 1] = string.format("%s: %s", formatted_key, tostring(value))
                    end
                end
                context_menu_options[#context_menu_options+1] = {
                    type = 'drop',
                    header = item.label,
                    icon = 'fa-solid fa-box',
                    image = 'nui://boii_rp/html/assets/images/items/'..item.image,
                    message = item_messages,
                    submenu = {
                        {
                            header = 'Use',
                            message = 'Use this item.',
                            action_type = 'client',
                            action = 'boii_items:cl:use',
                            params = { item = item },
                            should_close = true
                        },
                        {
                            header = 'Drop x1',
                            message = 'Drop 1 of this item.',
                            action_type = 'server',
                            action = 'boii_items:sv:drop',
                            params = { item = item.id },
                            should_close = true
                        },
                        {
                            header = 'Drop All',
                            message = 'Drop all of this item.',
                            action_type = 'server',
                            action = 'boii_items:sv:drop',
                            params = { item = item.id, amount = item_data.quantity },
                            should_close = true
                        }
                    }
                }
            else
                debug_log('err', 'Function: open_inventory | Reason: Item details for ' .. item_id .. ' not found in shared.items.')
            end
        end
    else
        context_menu_options[1] = {
            type = 'regular',
            header = 'No Items',
            icon = 'fa-solid fa-box-open',
            message = 'You currently have no items in your inventory.',
        }
    end

    local context_menu = {
        header = {
            text = identity.first_name .. ' ' .. identity.last_name,
            message = {
                'ID: ' .. GetPlayerServerId(PlayerId()),
                'Slots: ' .. used_slots .. '/' .. inventory.slots,
                'Weight: ' .. total_item_weight .. '/' .. inventory.carry_weight .. 'g'
            },
            icon = 'fa-solid fa-box-open'
        },
        options = context_menu_options
    }
    exports.boii_ui:menu(context_menu)
end

--- @section Keymapping

--- Key map to open inventory
RegisterKeyMapping('inventory', 'Open Inventory (ESC to close)', 'keyboard', 'TAB')
RegisterCommand('inventory', function()
    if not inventory_open then
        local data = exports.boii_statuses:get_data()
        if not data.flags.handcuffed and not data.flags.ziptied and not data.flags.dead then
            open_inventory()
        end
    end
end)