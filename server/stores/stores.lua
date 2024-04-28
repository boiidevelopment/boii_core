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

--- Server side stores functions and events.
-- @script server/stores/stores.lua

--- @section Tables

--- Stores table
-- @field blip: Holds the blip information for the store.
-- @field ped: Holds the ped information for the store.
local stores = {
    -- General stores
    { 
        blip = { id = 'strawberry_247', type = 'general', label = 'General Store', coords = vector3(25.71, -1346.77, 29.5), category = 'general_store', sprite = 52, colour = 0, scale = 0.6, show = true },
        ped = { id = 'strawberry_247', type = 'general', label = 'Shop Keeper', model = 'mp_m_shopkeep_01', coords = vector4(24.47, -1346.62, 29.5, 271.66), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'general_store', networked = false }
    },
    { 
        blip = { id = 'vinewood_247', type = 'general', label = 'General Store', coords = vector3(373.86, 326.65, 103.57), category = 'general_store', sprite = 52, colour = 0, scale = 0.6, show = true },
        ped = { id = 'vinewood_247', type = 'general', label = 'Shop Keeper', model = 'mp_m_shopkeep_01', coords = vector4(372.66, 327.02, 103.57, 252.49), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'general_store', networked = false }
    },
    { 
        blip = { id = 'chumash_247', type = 'general', label = 'General Store', coords = vector3(-3242.82, 1001.25, 12.83), category = 'general_store', sprite = 52, colour = 0, scale = 0.6, show = true },
        ped = { id = 'chumash_247', type = 'general', label = 'Shop Keeper', model = 'mp_m_shopkeep_01', coords = vector4(-3242.87, 1000.02, 12.83, 352.01), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'general_store', networked = false }
    },
    { 
        blip = { id = 'great_ocean_247', type = 'general', label = 'General Store', coords = vector3(1729.13, 6415.08, 35.04), category = 'general_store', sprite = 52, colour = 0, scale = 0.6, show = true },
        ped = { id = 'great_ocean_247', type = 'general', label = 'Shop Keeper', model = 'mp_m_shopkeep_01', coords = vector4(1728.09, 6415.76, 35.04, 241.66), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'general_store', networked = false }
    },
    { 
        blip = { id = 'sandy_shores_247', type = 'general', label = 'General Store', coords = vector3(1960.94, 3741.1, 32.34), category = 'general_store', sprite = 52, colour = 0, scale = 0.6, show = true },
        ped = { id = 'sandy_shores_247', type = 'general', label = 'Shop Keeper', model = 'mp_m_shopkeep_01', coords = vector4(1959.87, 3740.42, 32.34, 294.63), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'general_store', networked = false }
    },
    { 
        blip = { id = 'route68_247', type = 'general', label = 'General Store', coords = vector3(547.92, 2670.69, 42.16), category = 'general_store', sprite = 52, colour = 0, scale = 0.6, show = true },
        ped = { id = 'route68_247', type = 'general', label = 'Shop Keeper', model = 'mp_m_shopkeep_01', coords = vector4(549.13, 2670.83, 42.16, 95.13), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'general_store', networked = false }
    },
    { 
        blip = { id = 'grand_senora_247', type = 'general', label = 'General Store', coords = vector3(2678.07, 3280.75, 55.24), category = 'general_store', sprite = 52, colour = 0, scale = 0.6, show = true },
        ped = { id = 'grand_senora_247', type = 'general', label = 'Shop Keeper', model = 'mp_m_shopkeep_01', coords = vector4(2677.4, 3279.65, 55.24, 327.15), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'general_store', networked = false }
    },
    { 
        blip = { id = 'great_ocean2_247', type = 'general', label = 'General Store', coords = vector3(-3039.75, 585.52, 7.91), category = 'general_store', sprite = 52, colour = 0, scale = 0.6, show = true },
        ped = { id = 'great_ocean2_247', type = 'general', label = 'Shop Keeper', model = 'mp_m_shopkeep_01', coords = vector4(-3039.32, 584.38, 7.91, 15.29), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'general_store', networked = false }
    },
    { 
        blip = { id = 'palomino_247', type = 'general', label = 'General Store', coords = vector3(2556.77, 382.11, 108.62), category = 'general_store', sprite = 52, colour = 0, scale = 0.6, show = true },
        ped = { id = 'palomino_247', type = 'general', label = 'Shop Keeper', model = 'mp_m_shopkeep_01', coords = vector4(2556.75, 380.77, 108.62, 355.81), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'general_store', networked = false }
    },

    -- Ammunations
    { 
        blip = { id = 'palomino_ammu', type = 'ammunation', label = 'Weapon Store', coords = vector3(2567.38, 293.96, 108.73), category = 'ammunation', sprite = 110, colour = 0, scale = 0.6, show = true },
        ped = { id = 'palomino_ammu', type = 'ammunation', label = 'Shop Keeper', model = 's_m_y_ammucity_01', coords = vector4(2567.14, 292.54, 108.73, 359.04), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'ammunation', networked = false }
    },
    { 
        blip = { id = 'little_seoul_ammu', type = 'ammunation', label = 'Weapon Store', coords = vector3(-661.82, -934.86, 21.83), category = 'ammunation', sprite = 110, colour = 0, scale = 0.6, show = true },
        ped = { id = 'little_seoul_ammu', type = 'ammunation', label = 'Shop Keeper', model = 's_m_y_ammucity_01', coords = vector4(-661.6, -933.58, 21.83, 178.73), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'ammunation', networked = false }
    },
    { 
        blip = { id = 'sandy_shores_ammu', type = 'ammunation', label = 'Weapon Store', coords = vector3(1693.63, 3760.44, 34.71), category = 'ammunation', sprite = 110, colour = 0, scale = 0.6, show = true },
        ped = { id = 'sandy_shores_ammu', type = 'ammunation', label = 'Shop Keeper', model = 's_m_y_ammucity_01', coords = vector4(1692.99, 3761.69, 34.71, 226.35), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'ammunation', networked = false }
    },
    { 
        blip = { id = 'morningwood_ammu', type = 'ammunation', label = 'Weapon Store', coords = vector3(-1305.49, -394.84, 36.7), category = 'ammunation', sprite = 110, colour = 0, scale = 0.6, show = true },
        ped = { id = 'morningwood_ammu', type = 'ammunation', label = 'Shop Keeper', model = 's_m_y_ammucity_01', coords = vector4(-1304.34, -395.52, 36.7, 71.94), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'ammunation', networked = false }
    },
    { 
        blip = { id = 'chumash_ammu', type = 'ammunation', label = 'Weapon Store', coords = vector3(-3172.11, 1088.38, 20.84), category = 'ammunation', sprite = 110, colour = 0, scale = 0.6, show = true },
        ped = { id = 'chumash_ammu', type = 'ammunation', label = 'Shop Keeper', model = 's_m_y_ammucity_01', coords = vector4(-3173.31, 1089.04, 20.84, 244.49), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'ammunation', networked = false }
    },
    { 
        blip = { id = 'vespucci_ammu', type = 'ammunation', label = 'Weapon Store', coords = vector3(842.03, -1033.94, 28.19), category = 'ammunation', sprite = 110, colour = 0, scale = 0.6, show = true },
        ped = { id = 'vespucci_ammu', type = 'ammunation', label = 'Shop Keeper', model = 's_m_y_ammucity_01', coords = vector4(841.44, -1035.37, 28.19, 357.53), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'ammunation', networked = false }
    },
    { 
        blip = { id = 'paleto_ammu', type = 'ammunation', label = 'Weapon Store', coords = vector3(-330.35, 6084.44, 31.45), category = 'ammunation', sprite = 110, colour = 0, scale = 0.6, show = true },
        ped = { id = 'paleto_ammu', type = 'ammunation', label = 'Shop Keeper', model = 's_m_y_ammucity_01', coords = vector4(-331.05, 6085.61, 31.45, 225.31), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'ammunation', networked = false }
    },
    { 
        blip = { id = 'adams_ammu', type = 'ammunation', label = 'Weapon Store', coords = vector3(22.61, -1106.86, 29.8), category = 'ammunation', sprite = 110, colour = 0, scale = 0.6, show = true },
        ped = { id = 'adams_ammu', type = 'ammunation', label = 'Shop Keeper', model = 's_m_y_ammucity_01', coords = vector4(23.38, -1105.8, 29.8, 159.39), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'ammunation', networked = false }
    },
    { 
        blip = { id = 'hawick_ammu', type = 'ammunation', label = 'Weapon Store', coords = vector3(252.4, -50.59, 69.94), category = 'ammunation', sprite = 110, colour = 0, scale = 0.6, show = true },
        ped = { id = 'hawick_ammu', type = 'ammunation', label = 'Shop Keeper', model = 's_m_y_ammucity_01', coords = vector4(253.52, -51.32, 69.94, 67.7), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'ammunation', networked = false }
    },
    { 
        blip = { id = 'cypress_ammu', type = 'ammunation', label = 'Weapon Store', coords = vector3(809.81, -2157.68, 29.62), category = 'ammunation', sprite = 110, colour = 0, scale = 0.6, show = true },
        ped = { id = 'cypress_ammu', type = 'ammunation', label = 'Shop Keeper', model = 's_m_y_ammucity_01', coords = vector4(809.49, -2159.0, 29.62, 357.06), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'ammunation', networked = false }
    },
    { 
        blip = { id = 'route68_ammu', type = 'ammunation', label = 'Weapon Store', coords = vector3(-1117.86, 2698.95, 18.55), category = 'ammunation', sprite = 110, colour = 0, scale = 0.6, show = true },
        ped = { id = 'route68_ammu', type = 'ammunation', label = 'Shop Keeper', model = 's_m_y_ammucity_01', coords = vector4(-1118.36, 2700.34, 18.55, 220.44), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'ammunation', networked = false }
    }
}

--- Items 
-- @field id: ID for the item, this should match the key.
-- @field label: Human readable label for the item.
-- @field image: Image for the item.
-- @field price: Purchasing price for the item.
-- @field locations: Which stores the items should be inside.
-- @field categories: Which categories the item fits into, this is purely for display purposes.
local items = {
    -- General
    water = { id = 'water', label = 'Water', image = 'water.png', price = 3, locations = { 'general' }, categories = { 'consumables' } },
    burger = { id = 'burger', label = 'Burger', image = 'burger.png', price = 5, locations = { 'general' }, categories = { 'consumables' } },

    -- Ammunation
    weapon_pistol = { id = 'weapon_pistol', label = 'Pistol', image = 'weapon_pistol.png', price = 5000, locations = { 'ammunation' }, categories = { 'weapons' } },
    ammo_pistol = { id = 'ammo_pistol', label = 'Pistol Ammo', image = 'ammo_pistol.png', price = 200, locations = { 'ammunation' }, categories = { 'ammo' } },
    default_clip_pistol = { id = 'default_clip_pistol', label = 'Default Clip: Pistol', image = 'default_clip_pistol.png', price = 200, locations = { 'ammunation' }, categories = { 'weapon_attachments' } },
    extended_clip_pistol = { id = 'extended_clip_pistol', label = 'Extended Clip: Pistol', image = 'extended_clip_pistol.png', price = 500, locations = { 'ammunation' }, categories = { 'weapon_attachments' } },
    attachment_flashlight = { id = 'attachment_flashlight', label = 'Flashlight Attachment', image = 'attachment_flashlight.png', price = 100, locations = { 'ammunation' }, categories = { 'weapon_attachments' } },
    body_armour = { id = 'body_armour', label = 'Body Armour', image = 'body_armour.png', price = 1000, locations = { 'ammunation' }, categories = { 'clothing' } },
    repair_kit_pistol = { id = 'repair_kit_pistol', label = 'Pistol Repair Kit', image = 'repair_kit_pistol.png', price = 100, locations = { 'ammunation' }, categories = { 'repair_kits' } }
}

--- @section Local functions

--- Function to get a prepare the store data depending on store type
-- @param store_type: String name for type of store. 
local function get_store_data(store_type)
    local headers = {
        general = { text = 'General Store', message = { 'You can buy general use stuff here.' }, icon = 'fa-solid fa-shopping-basket' },
        ammunation = { text = 'Ammunation', message = { 'You can buy weapons and ammo here.' }, icon = 'fa-solid fa-gun' }
    }
    local store_data = { header = headers[store_type], items = {} }
    for _, item in pairs(items) do
        if utils.tables.table_contains(item.locations, store_type) then
            store_data.items[#store_data.items + 1] = item
        end
    end
    return store_data
end

--- @section Events

--- Event to get store data and return to client to load store UI.
RegisterServerEvent('boii:sv:load_store', function(params)
    local _src = source
    local store_data = get_store_data(params.store)
    TriggerClientEvent('boii:cl:open_store', _src, store_data)
end)

--- Event to purchase items from stores.
RegisterServerEvent('boii:sv:purchase_item', function(params)
    local _src = source
    local item_id = params.item
    local price = params.price
    local item_amount = params.values.number
    if not item_id then
        debug_log('err', 'Event: boii:sv:purchase_item | Reason: Item ID was not found or is missing.')
        return
    end
    local item_data = exports.boii_items:find_item(item_id)
    if not item_data then
        debug_log('err', 'Event: boii:sv:purchase_item | Reason: Item data could not be retrieved.')
        return
    end
    local items_to_add = {
        { item_id = item_id, action = 'add', quantity = item_amount }
    }
    if item_data.data then
        items_to_add[1].data = item_data.data
    end
    local balance = utils.fw.get_balance_by_type(_src, 'bank')
    local price_to_pay = math.ceil(item_amount * price)
    if balance < price_to_pay then
        utils.ui.notify(_src, {
            header = 'Transaction Failed',
            message = 'Insufficient funds for the requested transaction.',
            type = 'error',
            duration = 3500
        })
        return
    end
    utils.fw.adjust_balance(_src, {
        operations = {
            {balance_type = 'bank', action = 'remove', amount = price_to_pay},
        }, 
        reason = 'Stores: Purchased item.', 
        should_save = true
    })
    utils.fw.adjust_inventory(_src, {
        items = items_to_add,
        note = 'Stores: Purchased item.',
        should_save = true
    })
    utils.ui.notify(_src, {
        header = 'STORES',
        message = 'You purchased ' .. item_amount .. 'x ' .. item_data.label,
        type = 'success',
        duration = 3000
    })
end)

--- @section Callbacks

--- Server callback to provide ATM configurations to the client.
-- @param _src: The player's server ID requesting the data.
-- @param data: Unused parameter for consistency with callback pattern.
-- @param cb: Callback function to return the stores.
utils.callback.register('boii:sv:request_stores', function(_src, data, cb)
    cb(utils.tables.deep_copy(stores))
end)