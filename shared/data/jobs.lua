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

--- Shared data for job configurations.
-- @script shared/data/jobs.lua

--- Jobs
shared.jobs = {
    --- Job: Unemployed
    -- The 'Unemployed' job serves as a default or placeholder job. It's used to ensure every player has a basic income and job structure,
    -- even if they're not actively engaged in a specific profession. This job can be used as a starting point for new players or a fallback for players between jobs.
    unemployed = {
        id = 'unemployed',  -- The unique identifier for the job. It's used in scripts to refer to this specific job.
        type = 'primary',  -- The type of job. A 'primary' job is the main occupation of a player. Players can typically have only one primary job.
        category = 'civilian',  -- The general category of the job. Categories help organize jobs into groups for administrative and gameplay purposes.
        label = 'Unemployed',  -- The display name of the job. This is the name shown to players in the game's UI, like job selection screens or player profiles.
        image = 'unemployed_job_logo.png',  -- The filepath to the job's display image. This image can be used in menus or player profiles to represent the job visually.
        periodic_pay = true, -- This flag indicates whether the job will award pay to the player periodically based on the pay_frequency. If this is false players will not receive "state" payments.
        off_duty_pay = true,  -- This flag indicates whether players receive payment even when they're not actively working or 'on-duty'. For 'Unemployed', this might represent a basic welfare system.
        direct_pay = false,  -- This flag indicates how players receive their payment. If false, players need to visit a location in-game to collect their earnings *(default pacific bank)*.
        pay_frequency = 15,  -- This value defines the interval, in minutes, between each payment cycle. It determines how often players are paid for their job.
        
        -- The 'grades' section defines different levels or positions within a job. Each grade can have different pay, responsibilities, and access rights.
        grades = {
            ['0'] = {
                name = 'unemployed',  -- A unique identifier for the grade within the job. Used in scripts to refer to this specific grade.
                label = 'Unemployed',  -- The display name for the grade. Shown to players in the game's UI.
                
                -- Example usage for the 'access' field:
                -- This code snippet demonstrates how you might check if a player has access to certain vehicles or buildings based on their job grade.
                -- @usage
                --[[
                    local player_data = boii.get_data().job
                    local job = player_data.job.id
                    local job_grade = player_data.job.grade
                    local job_data = boii.shared.gangs[job].grades[job_grade].access
                    for category, items in pairs(job_data) do
                        if category == 'vehicles' then
                            for _, vehicle in ipairs(items) do
                                if has_vehicle_access(player, vehicle) then
                                    print("Player has access to vehicle: " .. vehicle)
                                end
                            end
                        elseif category == 'areas' then
                            for _, building in ipairs(items) do
                                if player_has_access(player, building) then
                                    print("Player has access to building: " .. building)
                                end
                            end
                        end
                    end
                ]]
                access = {},
                
                require_on_duty = false,  -- This flag indicates whether a player needs to be 'on-duty' to access job resources and receive pay. For 'Unemployed', this is typically false.
                
                -- The 'promotion' field outlines the prerequisites for a player to advance to the next grade within their job.
                -- It can encompass time spent at the current grade or specific tasks that need to be completed.
                -- This is instrumental in structuring a progression system within the job, adding depth to the roleplay elements.
                -- @example: { time_in_grade = 720, tasks_completed = { 'attend_job_fair', 'submit_resume' } }
                -- @usage
                --[[
                    local player_data = boii.get_data().job
                    local job = player_data.job.id
                    local job_grade = player_data.job.grade
                    local job_data = boii.shared.gangs[job].grades[job_grade].promotion
                    if player_meets_requirements(player, job_data) then
                        promote_player(player)
                    end
                ]]
                promotion = {},
                
                -- The 'income' field details how a player's income is calculated, including base pay, overtime, and bonuses.
                -- This allows for a dynamic and flexible pay system that can reward players for extra work or exceptional performance.
                income = {
                    pay = 10,  -- The base amount paid to players in this grade each pay cycle. Can be used as a basic income for players without a job.
                    overtime_rate = 1.0,  -- The multiplier applied to the base pay for overtime hours.
                    overtime_threshold = 0,  -- The number of hours a player must work before the overtime rate applies.
                    
                    -- The 'bonuses' field specifies additional incentives or rewards that can be granted to players based on certain conditions, achievements, or performance metrics.
                    -- These bonuses can be used to encourage specific behaviors or reward players for their contributions and achievements within the server.
                    -- @example: { attendance_bonus = 5, performance_bonus = 10 }
                    -- @usage
                    --[[
                        -- This code snippet demonstrates how to calculate the total pay including bonuses for a player.
                        local player_data = boii.get_data().job
                        local job = player_data.job.id
                        local job_grade = player_data.job.grade
                        local job_data = boii.shared.gangs[job].grades[job_grade].income
                        local total_pay = job_data.base_pay
                        for _, bonus_amount in pairs(job_data.bonuses) do
                            total_pay = total_pay + bonus_amount
                        end
                        print("Total pay including bonuses: " .. total_pay)
                    ]]
                    bonuses = {},
                },
                
                -- The 'attributes' field allows for the definition of special characteristics, skills, or reputation levels associated with a job grade.
                -- Attributes can influence gameplay, unlock additional content, or affect how other players and NPCs interact with the player.
                -- @example: { community_involvement = 20, professionalism = 15 }
                -- @usage
                --[[
                    -- This code snippet demonstrates how you might use attributes to grant access to a special event or location.
                    local player_data = boii.get_data().job
                    local job = player_data.job.id
                    local job_grade = player_data.job.grade
                    local job_data = boii.shared.gangs[job].grades[job_grade].attributes
                    if job_data.community_involvement >= 20 then
                        grant_access_to_special_event(player)
                    end
                ]]
                attributes = {},
                
                -- The 'interactions' field defines the set of actions or activities available to players at this job grade.
                -- This can range from job-specific tasks to social interactions, contributing to a dynamic and interactive gameplay environment.
                -- @example: { volunteer = { 'food_bank', 'local_shelter' }, attend_events = { 'job_fair', 'community_meeting' } }
                -- @usage
                --[[
                    -- This code snippet demonstrates how to trigger specific interactions based on the player's job grade.
                    local player_data = boii.get_data().job
                    local job = player_data.job.id
                    local job_grade = player_data.job.grade
                    local job_data = boii.shared.gangs[job].grades[job_grade].interactions
                    for interaction, options in pairs(job_data) do
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
                
                -- The 'abilities' field identifies unique skills, abilities, or perks that are unlocked when a player reaches this job grade.
                -- These special abilities can offer gameplay advantages, access to exclusive content, or special features within the server.
                -- @example: { 'public_speaking', 'advanced_negotiation' }
                -- @usage
                --[[
                    -- This code snippet demonstrates how you might check for special abilities to unlock a feature or ability.
                    local player_data = boii.get_data().job
                    local job = player_data.job.id
                    local job_grade = player_data.job.grade
                    local job_data = boii.shared.gangs[job].grades[job_grade].abilities
                    if table.contains(job_data, 'public_speaking') then
                        unlock_public_speaking_feature(player)
                    end
                ]]
                abilities = {},

                -- The 'equipment' field specifies the tools, weapons, or other items that are provided to players at this job grade.
                -- This is particularly useful for roles that require specific equipment to perform job-related tasks or enhance the roleplay aspect.
                -- @example: { 'radio', 'first_aid_kit' }
                -- @usage
                --[[
                    -- This code snippet demonstrates how you might grant equipment to a player based on their job grade.
                    local player_data = boii.get_data().job
                    local job = player_data.job.id
                    local job_grade = player_data.job.grade
                    local job_data = boii.shared.gangs[job].grades[job_grade].equipment
                    for _, item in ipairs(job_data) do
                        grant_equipment_to_player(player, item)
                    end
                ]]
                equipment = {},

                -- The 'outfits' field specifies the attire or outfits associated with the job grade.
                -- This is particularly useful for jobs that require a specific appearance, such as police officers, medical staff, or service industry workers.
                -- @example { 'police_uniform', 'police_tactical' }
                -- @usage
                --[[
                    -- This code snippet demonstrates how you might enforce outfit requirements for a player based on their job grade.
                    local player_data = boii.get_data().job
                    local job = player_data.job.id
                    local job_grade = player_data.job.grade
                    local job_data = boii.shared.gangs[job].grades[job_grade].outfits
                    for _, outfits in pairs(job_data) do
                        grant_outfit_to_player(player, outfit)
                    end
                ]]
                outfits = {},
            }
        }
    },
    
    --- Job: Police
    police = {
        id = 'police',
        type = 'primary',
        category = 'law_enforcement',
        label = 'Police Officer',
        image = 'police_job_logo.png',
        periodic_pay = true,
        off_duty_pay = false,
        direct_pay = true,
        pay_frequency = 30,
        grades = {
            ['0'] = {
                name = 'cadet',
                label = 'Cadet',
                pay = 500,
                access = {
                    vehicles = { 'police_car', 'police_helicopter' },
                    doors = { 'police_station_front' },
                    zones = { 'police_garage', 'police_armoury' },
                    items = { 'handcuff', 'badge', 'weapon' }
                },
                require_on_duty = true,
                promotion = {
                    time_in_grade = 36,
                    tasks_completed = { 'attend_5_training_sessions', 'pass_physical_exam' },
                    training = { 'firearm_safety', 'crisis_negotiation', 'first_responder_course' }
                },
                income = {
                    overtime_rate = 1.5,
                    overtime_threshold = 8,
                    bonuses = { weekend_bonus = 100, hazard_pay = 50 }
                },
                attributes = { public_appeal = 10 },
                interactions = {
                    player = { 'handcuff', 'read_rights' },
                    locations = { 'reset_bank_heist' }
                },
                abilities = { 'fast_sprinting', 'sharp_shooting' },
                equipment = { 'radio', 'first_aid_kit', 'body_armor' },
                outfits = { 'police_uniform' }
            }
        }
    }
}