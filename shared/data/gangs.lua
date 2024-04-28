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

--- Shared data for gang configurations.
-- @script shared/data/gangs.lua
 
--- Gangs
shared.gangs = {
    --- Gang: Unaffiliated
    -- The 'Unaffiliated' gang serves as a default or placeholder group. It's used to ensure every player has a basic organizational structure,
    -- even if they're not actively engaged in a specific gang. This can be used as a starting point for new players or a fallback for players between gangs.
    unaffiliated = {
        id = 'unaffiliated',  -- Unique identifier for the gang. Used in scripts to refer to this specific gang.
        type = 'gang',  -- Type of organization. 'gang' indicates an illegal or underground operation.
        category = 'criminal',  -- General category for organizational purposes. Useful for segmenting gangs into broad groups for UI presentation or logic grouping.
        label = 'Unaffiliated',  -- Display name of the gang. Shown to players in the game's UI, like gang selection screens or player profiles.
        image = 'unaffiliated_logo.png',  -- Path to the gang's display image. Used to visually represent the gang in user interfaces.

        -- The 'ranks' section defines different levels or positions within a gang. Each rank can have different responsibilities and access rights.
        ranks = {
            ['0'] = {
                name = 'associate',  -- Internal identifier for the rank within the gang. Used in code to reference this specific rank.
                label = 'Associate',  -- Display name for the rank. Shown to players in interfaces like promotion lists or rank overviews.

                -- The 'access' field defines what resources, areas, or items a player at this rank has access to.
                -- For example, a gang member might have access to safe houses and specific vehicles.
                -- @example { vehicles = {'bicycle'}, areas = {'hideout'} }
                -- @usage
                --[[
                    local player_data = boii.get_data().gang
                    local gang = player_data.gang.id
                    local gang_rank = player_data.gang.rank
                    local gang_data = boii.shared.gangs[gang].ranks[gang_rank]
                    for category, items in pairs(gang_data.access) do
                        if category == 'vehicles' then
                            for _, vehicle in ipairs(items) do
                                if has_vehicle_access(player, vehicle) then
                                    print("Player has access to vehicle: " .. vehicle)
                                end
                            end
                        elseif category == 'areas' then
                            for _, area in ipairs(items) do
                                if has_area_access(player, area) then
                                    print("Player has access to area: " .. area)
                                end
                            end
                        end
                    end
                ]]
                access = {},

                -- The 'promotion_requirements' field outlines the prerequisites for a player to advance to the next grade within their job.
                -- It can encompass time spent at the current grade or specific tasks that need to be completed.
                -- This is instrumental in structuring a progression system within the job, adding depth to the roleplay elements.
                -- @example: { time_in_grade = 72, tasks_completed = { 'tag_hoods', 'boost_cars' } }
                -- @usage
                --[[
                    -- When a player attempts to get promoted, you can check if they meet the requirements like this:
                    local player_data = boii.get_data().gang
                    local gang = player_data.gang.id
                    local gang_rank = player_data.gang.rank
                    if player_meets_requirements(player, gang, gang_rank) then
                        promote_player(player)
                    end
                ]]
                promotion_requirements = {},

                -- The 'attributes' field allows for the definition of special characteristics, skills, or reputation levels associated with a job grade.
                -- Attributes can influence gameplay, unlock additional content, or affect how other players and NPCs interact with the player.
                -- @example: { street_cred = 20 }
                -- @usage
                --[[
                    -- This code snippet demonstrates how you might use attributes to grant access to a special event or location.
                    local player_data = boii.get_data().gang
                    local gang = player_data.gang.id
                    local gang_rank = player_data.gang.rank
                    local gang_data = boii.shared.gangs[gang].ranks[gang_rank]
                    if gang_data.attributes.street_cred >= 20 then
                        grant_access_to_special_event(player)
                    end
                ]]
                attributes = {},

                 -- The 'interactions' field defines the set of actions or activities available to players at this job grade.
                -- This can range from job-specific tasks to social interactions, contributing to a dynamic and interactive gameplay environment.
                -- @example: { volunteer = { 'food_bank', 'local_shelter' }, attend_events = { 'job_fair', 'community_meeting' } }
                -- @usage
                --[[
                    -- This code snippet demonstrates how to trigger specific interactions based on the player's gang grade.
                    local player_data = boii.get_data().gang
                    local gang = player_data.gang.id
                    local gang_rank = player_data.gang.rank
                    local gang_data = boii.shared.gangs[gang].ranks[gang_rank]
                    for interaction, options in pairs(gang_data.interactions) do
                        if interaction == 'volunteer' then
                            for _, place in ipairs(options) do
                                initiate_volunteer_activity(player, place)
                            end
                        elseif interaction == 'attend_events' then
                            for _, event in ipairs(options) do
                                attend_event(player, event)
                            end
                        end
                    end
                ]]
                interactions = {},

                -- The 'abilities' field identifies unique skills, abilities, or perks that are unlocked when a player reaches this gang grade.
                -- These special abilities can offer gameplay advantages, access to exclusive content, or special features within the server.
                -- @example: { 'public_speaking', 'advanced_negotiation' }
                -- @usage
                --[[
                    -- This code snippet demonstrates how you might check for special abilities to unlock a feature or ability.
                    local player_data = boii.get_data().gang
                    local gang = player_data.gang.id
                    local gang_rank = player_data.gang.rank
                    local gang_data = boii.shared.gangs[gang].ranks[gang_rank]
                    if table.contains(gang_data.abilities, 'public_speaking') then
                        unlock_public_speaking_feature(player)
                    end
                ]]
                abilities = {},

                -- The 'equipment' field specifies the tools, weapons, or other items that are provided to players at this gang rank.
                -- This is particularly useful for roles that require specific equipment to perform gang-related tasks or enhance the roleplay aspect.
                -- @example: equipment = { 'bandana', '9mm_pistol' }
                -- @usage
                --[[
                    -- This code snippet demonstrates how you might grant equipment to a player based on their gang rank.
                    local player_data = boii.get_data().gang
                    local gang = player_data.gang.id
                    local gang_rank = player_data.gang.rank
                    local gang_data = boii.shared.gangs[gang].ranks[gang_rank]
                    for _, item in ipairs(gang_data.equipment) do
                        grant_equipment_to_player(player, item)
                    end
                ]]
                equipment = {},

                -- The 'outfits' field specifies the attire or outfits associated with the gang rank.
                -- This is particularly useful for setting a visual identity for gang members and enhancing the roleplay aspect.
                -- @example: { 'gang_casual', 'gang_turf' }
                -- @usage
                --[[
                    -- This code snippet demonstrates how you might grant outfit options to a player based on their gang rank.
                    local player_data = boii.get_data().gang
                    local gang = player_data.gang.id
                    local gang_rank = player_data.gang.rank
                    local gang_data = boii.shared.gangs[gang].ranks[gang_rank]
                    for _, outfit in pairs(gang_data.outfits) do
                        grant_outfit_to_player(player, outfit)
                    end
                ]]
                outfits = {}
            }
            -- Add more ranks here
        }
    },

    --- Gang: Ballas
    ballas = {
        id = 'ballas',
        type = 'gang',
        category = 'criminal',
        label = 'Ballas',
        image = 'ballas_logo.png',
        ranks = {
            ['0'] = {
                name = 'newcomer',
                label = 'Newcomer',
                access = {
                    vehicles = { 'lowrider1', 'lowrider2' },
                    areas = { 'gang_garage', 'gang_store' },
                    items = { 'graffiti_spray', 'lockpick' }
                },
                promotion_requirements = {
                    time_in_rank = 72,
                    missions_completed = { 'tagging_turf', 'corner_hustle' },
                },
                attributes = { street_cred = 10 },
                interactions = {
                    deal = { 'street_deal' },
                    conflict = { 'turf_defense' }
                },
                abilities = { 'drive_by', 'intimidation' },
                equipment = { 'bandana', '9mm_pistol' },
                outfits = { 'gang_casual', 'gang_turf' }
            }
            -- Add more ranks here
        }
    }
    -- Add more gangs here
}
