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

--- Dialogue conversations for various elements.
-- @script client/dialogues/dialogues.lua

local dialogues = dialogues or {}

dialogues.stores = dialogues.stores or {}
dialogues.banks = dialogues.banks or {}

dialogues.stores.general = {
    header = {
        message = 'Welcome to the General Store!',
        icon = 'fa-solid fa-shopping-basket'
    },
    conversation = {
        {
            id = 1,
            response = 'Hello! Welcome to our General Store. What brings you in today?',
            options = {
                {
                    icon = 'fa-solid fa-question-circle',
                    message = 'Can you tell me more about your store?',
                    next_id = 2,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-box-open',
                    message = 'Id like to see whats for sale.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii:sv:load_store',
                    params = {
                        store = 'general'
                    }
                },
                {
                    icon = 'fa-solid fa-door-open',
                    message = 'Just browsing for now, thanks!',
                    next_id = nil,
                    should_end = true
                }
            }
        },
        {
            id = 2,
            response = 'Our store offers a wide range of products, from daily necessities to special items. Whether youre looking for food, drinks, or something unique, weve got you covered!',
            options = {
                {
                    icon = 'fa-solid fa-arrow-left',
                    message = 'Back to previous questions.',
                    next_id = 1,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-box-open',
                    message = 'Show me what you have for sale.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii:sv:load_store',
                    params = {
                        store = 'general'
                    }
                },
                {
                    icon = 'fa-solid fa-door-open',
                    message = 'Thanks, Ill take a look around.',
                    next_id = nil,
                    should_end = true
                }
            }
        },
    }
}

dialogues.stores.ammunation = {
    header = {
        message = 'Welcome to Ammunation!',
        icon = 'fa-solid fa-gun'
    },
    conversation = {
        {
            id = 1,
            response = 'Welcome to Ammunation! Your one-stop shop for all your firearm needs. How can I assist you today?',
            options = {
                {
                    icon = 'fa-solid fa-question-circle',
                    message = 'Can you tell me more about what you offer?',
                    next_id = 2,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-box-open',
                    message = 'Id like to see your selection of firearms.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii:sv:load_store',
                    params = {
                        store = 'ammunation'
                    }
                },
                {
                    icon = 'fa-solid fa-door-open',
                    message = 'Just having a look around, thanks!',
                    next_id = nil,
                    should_end = true
                }
            }
        },
        {
            id = 2,
            response = 'We specialize in a wide range of firearms and ammunition, including pistols, rifles, shotguns, and accessories. Whether youre looking for self-defense, sporting, or tactical gear, weve got you covered!',
            options = {
                {
                    icon = 'fa-solid fa-arrow-left',
                    message = 'Back to previous questions.',
                    next_id = 1,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-box-open',
                    message = 'Show me what firearms you have for sale.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii:sv:load_store',
                    params = {
                        store = 'ammunation'
                    }
                },
                {
                    icon = 'fa-solid fa-door-open',
                    message = 'Thanks, Ill just browse for now.',
                    next_id = nil,
                    should_end = true
                }
            }
        },
    }
}

dialogues.banks.fleeca = {
    header = {
        message = 'Welcome to Fleeca Bank!',
        icon = 'fa-solid fa-university'
    },
    conversation = {
        {
            id = 1,
            response = 'Welcome to Fleeca Bank! How can we assist you today?',
            options = {
                {
                    icon = 'fa-solid fa-university',
                    message = 'Id like to access my bank account.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii:sv:load_bank',
                    params = {
                        bank = 'fleeca',
                        account = 'bank'
                    }
                },
                {
                    icon = 'fa-solid fa-university',
                    message = 'Id like to access my savings account.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii:sv:load_bank',
                    params = {
                        bank = 'fleeca',
                        account = 'savings'
                    }
                },
                {
                    icon = 'fa-solid fa-question-circle',
                    message = 'What can I do here?',
                    next_id = 2,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-door-open',
                    message = 'Just visiting, thank you!',
                    next_id = nil,
                    should_end = true
                }
            }
        },
        {
            id = 2,
            response = 'At Fleeca Bank, you can access your bank account to manage funds, including deposits and withdrawals. Were here to help with all your banking needs!',
            options = {
                {
                    icon = 'fa-solid fa-arrow-left',
                    message = 'Thanks, can we discuss something else?',
                    next_id = 1,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-door-open',
                    message = 'I understand, that will be all.',
                    next_id = nil,
                    should_end = true
                }
            }
        }
    }
}

dialogues.banks.blaine_county = {
    header = {
        message = 'Welcome to Blaine County Bank!',
        icon = 'fa-solid fa-university'
    },
    conversation = {
        {
            id = 1,
            response = 'Welcome to Blaine County Bank! How can we assist you today?',
            options = {
                {
                    icon = 'fa-solid fa-university',
                    message = 'Id like to access my bank account.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii:sv:load_bank',
                    params = {
                        bank = 'blaine_county',
                        account = 'bank'
                    }
                },
                {
                    icon = 'fa-solid fa-university',
                    message = 'Id like to access my savings account.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii:sv:load_bank',
                    params = {
                        bank = 'blaine_county',
                        account = 'savings'
                    }
                },
                {
                    icon = 'fa-solid fa-question-circle',
                    message = 'What can I do here?',
                    next_id = 2,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-door-open',
                    message = 'Just visiting, thank you!',
                    next_id = nil,
                    should_end = true
                }
            }
        },
        {
            id = 2,
            response = 'At Blaine County Bank, you can access your bank account to manage funds, including deposits and withdrawals. Were here to help with all your banking needs!',
            options = {
                {
                    icon = 'fa-solid fa-arrow-left',
                    message = 'Thanks, can we discuss something else?',
                    next_id = 1,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-door-open',
                    message = 'I understand, that will be all.',
                    next_id = nil,
                    should_end = true
                }
            }
        }
    }
}

dialogues.banks.pacific = {
    header = {
        message = 'Welcome to Pacific Bank!',
        icon = 'fa-solid fa-university'
    },
    conversation = {
        {
            id = 1,
            response = 'Welcome to Pacific Bank, the leading financial institution. How can we assist you today?',
            options = {
                {
                    icon = 'fa-solid fa-university',
                    message = 'Id like to access my bank account.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii:sv:load_bank',
                    params = {
                        bank = 'pacific',
                        account = 'bank'
                    }
                },
                {
                    icon = 'fa-solid fa-university',
                    message = 'Id like to access my savings account.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii:sv:load_bank',
                    params = {
                        bank = 'pacific',
                        account = 'savings'
                    }
                },
                {
                    icon = 'fa-solid fa-university',
                    message = 'Id like to access my paychecks please.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii:sv:load_bank',
                    params = {
                        bank = 'pacific',
                        account = 'paychecks'
                    }
                },
                {
                    icon = 'fa-solid fa-question-circle',
                    message = 'What can I do here?',
                    next_id = 2,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-info-circle',
                    message = 'Tell me about collecting paychecks.',
                    next_id = 3,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-door-open',
                    message = 'Just browsing, thanks!',
                    next_id = nil,
                    should_end = true
                }
            }
        },
        {
            id = 2, 
            response = 'At Pacific Bank, you can access your bank account, manage funds, and collect your paychecks. Our comprehensive services are designed to cater to all your financial needs efficiently.',
            options = {
                {
                    icon = 'fa-solid fa-arrow-left',
                    message = 'Thanks, can we discuss something else?',
                    next_id = 1,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-door-open',
                    message = 'I understand, that will be all.',
                    next_id = nil,
                    should_end = true
                }
            }
        },
        {
            id = 3,
            response = 'Collecting paychecks at Pacific Bank is simple. Just visit us and use our terminals or speak with a teller. Ensure your employment details are up to date to guarantee prompt and accurate payment.',
            options = {
                {
                    icon = 'fa-solid fa-university',
                    message = 'Thanks can I access my account.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii:sv:load_bank',
                    params = {
                        bank = 'pacific',
                    }
                },
                {
                    icon = 'fa-solid fa-arrow-left',
                    message = 'Thanks, can we discuss something else?',
                    next_id = 1,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-door-open',
                    message = 'I understand, that will be all.',
                    next_id = nil,
                    should_end = true
                }
            }
        }
    }
}

--- Event to launch dialogue based on store type.
RegisterNetEvent('boii:cl:start_conversation', function(data)
    local location = data.location
    local key = data.key
    local type = data.type
    local ped, coords = utils.entities.get_closest_ped(vector3(location.x, location.y, location.z), 5.0)
    local dialogue = dialogues[key][type]
    for _, convo in pairs(dialogue.conversation) do
        for _, option in pairs(convo.options) do
            if option.action ~= nil and option.action ~= '' then
                option.params = option.params or {}
                option.params.location = vector3(location.x, location.y, location.z)
            end
        end
    end
    exports.boii_ui:dialogue(dialogue, ped, coords)
end)
