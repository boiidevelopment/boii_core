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

--- Client side stores functions and events.
-- @script client/stores/stores.lua

--- @section Local functions

--- Setup stores based on returned stores callback data
-- @param stores: Stores list stored in server/stores/stores.lua
local function setup_stores(stores)
    for _, store in ipairs(stores) do
        if store.blip then
            local b = store.blip
            utils.blips.create_blip({
                coords = b.coords,
                sprite = b.sprite,
                colour = b.colour,
                scale = b.scale,
                label = b.label,
                category = b.category,
                show = b.show
            })
        end
        if store.ped then
            local p = store.ped
            local ped_data = {
                base_data = {
                    id = p.id,
                    model = p.model,
                    coords = p.coords,
                    scenario = p.scenario,
                    category = p.category,
                    networked = p.networked
                }
            }
            local created_ped = utils.peds.create_ped(ped_data)
            exports.boii_target:add_entity_zone({created_ped}, {
                id = 'zone_' .. p.id,
                icon = 'fa-solid fa-user',
                distance = 5.0,
                debug = false,
                sprite = true,
                actions = {
                    {
                        label = 'Talk To Shop-Keeper',
                        icon = 'fa-solid fa-hand-paper',
                        action_type = 'client',
                        action = 'boii:cl:start_conversation',
                        params = {
                            location = p.coords,
                            key = 'stores',
                            type = p.type
                        },
                        can_interact = function(entity)
                            return entity == created_ped
                        end
                    },
                }
            })
        end
    end
end

--- Opens a store menu
-- @param store_data: Table of data sent from server for the store.
-- @todo Replace with an actual UI instead of using menu based system.
local function open_store(store_data)
    if not store_data or not store_data.items then
        utils.ui.notify({
            header = 'STORES',
            message = 'Cannot open store, store data missing or invalid.',
            type = 'error',
            duration = 3000
        })
        return
    end
    local context_menu_options = {}
    if #store_data.items > 0 then
        for _, item in ipairs(store_data.items) do
            local item_data = exports.boii_items:find_item(item.id)
            if item_data then
                context_menu_options[#context_menu_options+1] = {
                    type = 'input',
                    header = item.label,
                    icon = 'fa-solid fa-tag',
                    image = 'nui://boii_rp/html/assets/images/items/'..item.image,
                    message = {
                        'Price: $' .. item.price,
                        'Weight: ' .. item_data.weight .. 'g',
                        'Category: ' .. table.concat(item.categories, ', ')
                    },
                    fields = {
                        id = false,
                        number = true, 
                        text = false,
                    },
                    button = {
                        text = 'Purchase',
                        icon = 'fa-solid fa-plus',
                        action_type = 'server',
                        action = 'boii:sv:purchase_item',
                        params = { item = item.id, price = item.price },
                    },
                }
            else
                context_menu_options[#context_menu_options+1] = {
                    type = 'regular',
                    header = 'Item Data Missing',
                    icon = 'fa-solid fa-box-open',
                    message = 'Look like you havent added ' ..item.id .. ' to the items list.',
                    disabled = true
                }
            end
        end
    else
        context_menu_options[1] = {
            type = 'regular',
            header = 'No Items',
            icon = 'fa-solid fa-box-open',
            message = 'This store currently has no items available.',
        }
    end
    local context_menu = {
        header = store_data.header and {
            text = store_data.header.text,
            message = store_data.header.message,
            icon = store_data.header.icon
        } or {
            text = 'Store',
            message = { 'Who knows what you can buy here? No body told us.' },
            icon = 'fa-solid fa-shopping-basket'
        },
        options = context_menu_options
    }    
    exports.boii_ui:menu(context_menu)
end

--- @section Callbacks

--- Fetches and sets up store zones upon callback.
-- @param config table: The configuration data for ATMs received from the server.
utils.callback.cb('boii:sv:request_stores', {}, function(stores)
    setup_stores(stores)
end)

--- @section Events

--- Event to open the store menu this is triggered from the server
RegisterNetEvent('boii:cl:open_store', function(store_data)
    open_store(store_data)
end)

--- Event handler for resource stop to trigger clean up.
AddEventHandler('onResourceStop', function(res)
    if GetCurrentResourceName() ~= res then
        return
    end
    utils.blips.remove_blips_by_categories({'general_store', 'ammunation'})
    utils.peds.remove_peds_by_categories({'general_store', 'ammunation'})
end)