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

--- Client side banking functions and events.
-- @script client/banking/banking.lua

--- @section Local functions

--- Setup banks based on returned banks callback data
-- @param banks: Banks list stored in server/banking/banking.lua
local function setup_banks(banks)
    for _, store in ipairs(banks) do
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
            exports['boii_target']:add_entity_zone({created_ped}, {
                id = 'zone_' .. p.id,
                icon = 'fa-solid fa-user',
                distance = 8.0,
                debug = false,
                sprite = true,
                actions = {
                    {
                        label = 'Talk To Bank Teller',
                        icon = 'fa-solid fa-university',
                        action_type = 'client',
                        action = 'boii:cl:start_conversation',
                        params = {
                            location = p.coords,
                            key = 'banks',
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

--- Opens a banking menu
-- @param banking_data: Table of data sent from server for the bank.
local function open_banking(account, banking_data)
    if not banking_data or not banking_data.balances then
        utils.notify.send({
            header = 'BANKS',
            message = 'Cannot open bank, bank data missing or invalid.',
            type = 'error',
            duration = 3000
        })
        return
    end
    local context_menu_options = {
        {
            type = 'regular',
            header = (account == 'bank' and 'Checking') or 'Savings',
            icon = 'fa-solid fa-money-check-alt',
            message = {
                'Balance: $' .. tostring(banking_data.balances[account].amount),
                'Interest Accrued: $' .. tostring(banking_data.balances[account].interest_accrued),
                'Interest Rate: ' .. string.format("%.1f%%", banking_data.balances[account].interest_rate * 100)
            }
        },
        {
            type = 'input',
            header = 'Withdraw',
            icon = 'fa-solid fa-money-check-alt',
            message = 'Withdraw funds from your ' .. account .. ' account',
            fields = {
                id = false,
                number = true,
                text = false,
            },
            button = {
                text = 'Submit', 
                icon = 'fa-solid fa-plus',
                action_type = 'server', 
                action = 'boii:sv:banking_transaction',
                params = {
                    balance = account,
                    action = 'withdraw'
                },
                should_close = true
            },
        },
        {
            type = 'input',
            header = 'Deposit',
            icon = 'fa-solid fa-money-check-alt',
            message = 'Deposit funds into your ' .. account .. ' account',
            fields = {
                id = false,
                number = true,
                text = false,
            },
            button = {
                text = 'Submit', 
                icon = 'fa-solid fa-plus',
                action_type = 'server', 
                action = 'boii:sv:banking_transaction',
                params = {
                    balance = account,
                    action = 'deposit'
                },
                should_close = true
            },
        }
    }
    local context_menu = {
        header = banking_data.header and {
            text = banking_data.header.text,
            message = banking_data.header.message,
            icon = banking_data.header.icon
        } or {
            text = 'Banking Services',
            message = { 'Access your accounts and manage your funds.' },
            icon = 'fa-solid fa-university'
        },
        options = context_menu_options
    }
    exports.boii_ui:menu(context_menu)
end

--- @section Callbacks

--- Fetches and sets up ATM zones upon callback.
-- @param config table: The configuration data for ATMs received from the server.
utils.callback.cb('boii:sv:request_banks', {}, function(banks)
    setup_banks(banks)
end)

--- @section Events

--- Event to open the store menu this is triggered from the server
RegisterNetEvent('boii:cl:open_bank', function(account, banking_data)
    open_banking(account, banking_data)
end)

--- Event handler for resource stop to trigger clean up.
AddEventHandler('onResourceStop', function(res)
    if GetCurrentResourceName() ~= res then
        return
    end
    utils.blips.remove_blips_by_categories({ 'bank' })
    utils.peds.remove_peds_by_categories({ 'bank' })
end)