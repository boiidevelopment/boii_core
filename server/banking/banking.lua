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

--- Server side banking functions and events.
-- @script server/banks/banks.lua

--- @section Tables

--- Banks table
-- @field blip: Holds the blip information for the bank.
-- @field ped: Holds the ped information for the bank.
local banks = {
    {
        blip = { id = 'fleeca_legion', type = 'fleeca', label = 'Bank', coords = vector3(149.78, -1040.79, 29.37), category = 'bank', sprite = 207, colour = 2, scale = 0.7, show = true },
        ped = { id = 'fleeca_legion', type = 'fleeca', label = 'Bank Teller', model = 'cs_molly', coords = vector4(149.4, -1042.06, 29.37, 338.43), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'bank', heading = 0.0, networked = false }
    },
    {
        blip = { id = 'fleeca_hawick', type = 'fleeca', label = 'Bank', coords = vector3(314.23, -279.10, 54.17), category = 'bank', sprite = 207, colour = 2, scale = 0.7, show = true },
        ped = { id = 'fleeca_hawick', type = 'fleeca', label = 'Bank Teller', model = 'cs_molly', coords = vector4(313.79, -280.43, 54.16, 341.71), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'bank', heading = 0.0, networked = false }
    },
    {
        blip = { id = 'fleeca_hawick2', type = 'fleeca', label = 'Bank', coords = vector3(-350.99, -49.99, 49.04), category = 'bank', sprite = 207, colour = 2, scale = 0.7, show = true },
        ped = { id = 'fleeca_hawick2', type = 'fleeca', label = 'Bank Teller', model = 'cs_molly', coords = vector4(-351.33, -51.25, 49.04, 340.12), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'bank', heading = 0.0, networked = false }
    },
    {
        blip = { id = 'fleeca_del_perro', type = 'fleeca', label = 'Bank', coords = vector3(-1212.54, -330.71, 37.79), category = 'bank', sprite = 207, colour = 2, scale = 0.7, show = true },
        ped = { id = 'fleeca_del_perro', type = 'fleeca', label = 'Bank Teller', model = 'cs_molly', coords = vector4(-1211.95, -331.99, 37.78, 25.02), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'bank', heading = 0.0, networked = false }
    },
    {
        blip = { id = 'fleeca_great_ocean', type = 'fleeca', label = 'Bank', coords = vector3(-2962.56, 482.92, 15.70), category = 'bank', sprite = 207, colour = 2, scale = 0.7, show = true },
        ped = { id = 'fleeca_great_ocean', type = 'fleeca', label = 'Bank Teller', model = 'cs_molly', coords = vector4(-2961.15, 482.89, 15.7, 87.88), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'bank', heading = 0.0, networked = false }
    },
    {
        blip = { id = 'fleeca_route68', type = 'fleeca', label = 'Bank', coords = vector3(1175.07, 2706.41, 38.09), category = 'bank', sprite = 207, colour = 2, scale = 0.7, show = true },
        ped = { id = 'fleeca_route68', type = 'fleeca', label = 'Bank Teller', model = 'cs_molly', coords = vector4(1175.01, 2708.22, 38.09, 181.46), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'bank', heading = 0.0, networked = false }
    },
    {
        blip = { id = 'blaine_county', type = 'blaine_county', label = 'Bank', coords = vector3(-113.22, 6470.03, 31.63), category = 'bank', sprite = 207, colour = 2, scale = 0.7, show = true },
        ped = { id = 'blaine_county', type = 'blaine_county', label = 'Bank Teller', model = 'cs_molly', coords = vector4(-111.21, 6470.02, 31.63, 131.78), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'bank', heading = 0.0, networked = false }
    },
    {
        blip = { id = 'pacific_bank', type = 'pacific', label = 'Bank', coords = vector3(246.64, 223.20, 106.29), category = 'bank', sprite = 207, colour = 2, scale = 0.7, show = true },
        ped = { id = 'pacific_bank', type = 'pacific', label = 'Bank Teller', model = 'cs_molly', coords = vector4(247.03, 225.0, 106.29, 157.9), scenario = 'WORLD_HUMAN_STAND_MOBILE', category = 'bank', heading = 0.0, networked = false }
    }
}

--- Function to get a prepare the bank data depending on bank type
-- @field bank_type: String name for type of bank. 
local function get_bank_data(balances, bank_type)
    local headers = {
        fleeca = { text = 'Fleeca Bank', message = { 'You can manage your balances here.' }, icon = 'fa-solid fa-building-columns' },
        blaine_county = { text = 'Blaine County Bank', message = { 'You can manage your balances here.' }, icon = 'fa-solid fa-building-columns' },
        pacific = { text = 'Pacific Bank', message = { 'You can manage your balances and paychecks here.' }, icon = 'fa-solid fa-building-columns' }
    }
    local bank_data = { header = headers[bank_type], balances = balances }
    return bank_data
end

--- @section Events

--- Event to get bank data and return to client to load bank UI.
RegisterServerEvent('boii:sv:load_bank', function(params)
    local _src = source
    local player = boii.get_player(_src)
    if not player then
        print('player not found')
        return
    end
    if not player.data.balances then 
        print('player balances not found')
        return 
    end
    local bank_data = get_bank_data(player.data.balances, params.bank)
    TriggerClientEvent('boii:cl:open_bank', _src, params.account, bank_data)
end)

--- Handles banking transactions
RegisterServerEvent('boii:sv:banking_transaction', function(params)
    local _src = source
    local account = params.balance
    local value = tonumber(params.values.number)
    local action = params.action
    local balance = utils.fw.get_balance_by_type(_src, account)
    local has_cash = utils.fw.has_item(_src, 'cash', value)
    if action == 'withdraw' and balance < value or action == 'deposit' and not has_cash then
        utils.ui.notify(_src, {
            header = 'Transaction Failed',
            message = 'Insufficient funds for the requested transaction.',
            type = 'error',
            duration = 3500
        })
        return
    end
    local bank_action = action == 'withdraw' and 'remove' or 'add'
    local cash_action = action == 'withdraw' and 'add' or 'remove'
    utils.fw.adjust_balance(_src, {
        operations = {
            { balance_type = account, action = bank_action, amount = value },
            { balance_type = 'cash', action = cash_action, amount = value }
        }, 
        reason = 'Banking transaction: ' .. (action == 'withdraw' and 'Withdrawal' or 'Deposit'),
        should_save = true
    })
    utils.ui.notify(_src, {
        header = 'Transaction Completed',
        message = (action == 'withdraw' and 'Withdrawn ' or 'Deposited ') .. '$' .. value .. ' successfully.',
        type = 'success',
        duration = 3500
    })
end)


--- @section Callbacks

--- Server callback to provide ATM configurations to the client.
-- @param _src: The player's server ID requesting the data.
-- @param data: Unused parameter for consistency with callback pattern.
-- @param cb: Callback function to return the banks.
utils.callback.register('boii:sv:request_banks', function(_src, data, cb)
    cb(utils.tables.deep_copy(banks))
end)