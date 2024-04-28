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

--- Server side default player data.
-- @see server/player/player_object.lua

--- @section Tables

--- Container for default player data settings.
-- @table PLAYER_DATA
PLAYER_DATA = PLAYER_DATA or {}

--- Player data types.
-- Lists the types of data associated with a player.
-- @field PLAYER_DATA_TYPES
-- @see process_data_types
PLAYER_DATA.DATA_TYPES = { 'identity', 'jobs', 'gang', 'balances', 'stats', 'inventory', 'position' }

--- Default player data to be applied to the player object
-- If the player does not have any data stored defaults will be inserted from this table
-- Data for returning players will be automatically updated with any missing default data when their object is created.
-- @field DEFAULT_PLAYER_DATA
-- @see create_player
PLAYER_DATA.DEFAULT_DATA = {
    identity = {
        first_name = 'John',
        last_name = 'Doe',
        dob = '1990-01-01',
        sex = 'male',
        nationality = 'LS, Los Santos',
        backstory = 'Placeholder backstory..'
    },
    jobs = {
        primary = {
            id = 'unemployed',
            type = 'primary',
            grade = '0',
            on_duty = false
        },
        secondary = {}
    },
    gang = {
        id = 'unaffiliated',
        rank = '0'
    },
    balances = {
        bank = {
            amount = 1000, 
            negative_allowed = true,
            interest_payout_timer = 24, -- hours real time.
            interest_rate = 0.002, -- 0.2%
            interest_accrued = 0,
            transaction_history = {}
        },
        savings = {
            amount = 0, 
            negative_allowed = false,
            interest_payout_timer = 24, -- hours real time.
            interest_rate = 0.025, -- 2.5%
            interest_accrued = 0,
            transaction_history = {}
        }
    },
    inventory = {
        slots = 36,
        carry_weight = 80000,
        items = {
            
        }
    },
    stats = {
        -- To be used to track data mainly for future planed achievements / multichar display mostly pointless but people might like it 
        -- General ?
        days_played = 0,
        achievements_unlocked = 0,
    
        -- Ownership ?
        vehicles_owned = 0,
        property_owned = 0,
        businesses_owned = 0,

        -- Legal ?
        items_crafted = 0,

        -- Criminal ?
        crimes_committed = 0,
        times_arrested = 0,
        enemies_defeated = 0,
    
        -- Social ?
        events_participated = 0,
        time_in_safezones = 0, 
    
        -- Medical ?
        died = 0,
        died_by_player = 0,
        died_by_ped = 0,
        died_by_animal = 0,
        respawned = 0,
        revived = 0,
        medical_treatment_received = 0,

        -- Economy ?
        total_spent = 0,
        total_earned = 0,
        legal_money_earned = 0,
        illegal_money_earned = 0,
        job_money_earned = 0
    },
    position = config.routing_buckets.main_world.locations.spawn
}