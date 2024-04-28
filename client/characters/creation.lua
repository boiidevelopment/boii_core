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

--- Client side character creation functions and events.
-- @script client/characters/creation.lua

--- @section Constants

--- Default ped location
-- @see setup_character_create
-- @see change_camera_position
local DEFAULT_PED_LOCATION = vector4(-1455.41, 221.05, 57.58, 269.29)

--- Camera positions to be used throughout creation process
-- @table CAMERA_POSITIONS
-- @see change_camera_position
local CAMERA_POSITIONS = {
    default_cam = { offset = { x = -0.05, y = 0.90, z = 0.45 }, height_adjustment = 0, near_dof = 0.7, far_dof = 1.3},
    face_cam = { offset = { x = -0.05, y = 0.55, z = 0.45 }, height_adjustment = 0.15, near_dof = 0.4, far_dof = 1.3 },
    body_cam = { offset = { x = -0.05, y = 1.75, z = 0.45 }, height_adjustment = -0.6, near_dof = 0.7, far_dof = 1.9 },
    leg_cam = { offset = { x = -0.05, y = 1.25, z = 0.45 }, height_adjustment = -0.80, near_dof = 0.7, far_dof = 1.5 },
    feet_cam = { offset = { x = -0.05, y = 1.25, z = 0.45 }, height_adjustment = -1.15, near_dof = 0.7, far_dof = 1.5 } 
}

--- @section Variables

--- Current sex of the player. Used to determine specific appearance settings.
-- This can be 'male' or 'female' and affects how certain appearance data is applied.
local current_sex = 'male'

--- Model identifier for the preview ped.
local preview_ped = (current_sex == 'male') and 'mp_m_freemode_01' or 'mp_f_freemode_01'

--- Camera object for viewing the ped.
local cam = nil

--- Ensures the load screen is handled only once.
local load_screen = false

--- Ensures setup_char_create only triggers on first spawn
local first_spawn = false

--- @section Local functions

--- Function to update values based on selected item in the character customization menu.
-- Sends an update to the NUI with the new clothing and prop values when a player selects a different item.
-- @function update_clothing_values
-- @param sex string: The sex of the current ped model ('male' or 'female').
-- @usage 
--[[
    update_clothing_values(sex)
]]
-- @example
--[[
    update_clothing_values('male')
]]
local function update_clothing_values(sex)
    local values = utils.character_creation.get_clothing_and_prop_values(sex)
    if not values then
        debug_log('err', 'Function: update_clothing_values failed. | Reason: Unable to retrieve clothing and prop values for sex: ' .. sex)
        return
    end
    SendNUIMessage({
        action = 'clothing_and_prop_values',
        values = values
    })
end

--- Function to setup character creation.
-- Initializes the character creation process by setting up the player model, applying default appearance,
-- positioning the camera, and managing NUI interactions.
-- @function setup_character_create
-- @usage 
--[[
    setup_character_create()
]]
local function setup_character_create()
    DoScreenFadeOut(10)
    SetNuiFocus(true, true)
    DisplayRadar(false)
    utils.callback.cb('boii:sv:get_character_list', {}, function(characters)
        local model
        if characters and #characters > 0 then
            local first_character = characters[1]
            current_sex = first_character.identity.sex
            preview_ped = (current_sex == 'male') and 'mp_m_freemode_01' or 'mp_f_freemode_01'
            model = GetHashKey(preview_ped)
            utils.requests.model(model)
            SetPlayerModel(PlayerId(), model)
            utils.character_creation.set_ped_appearance(PlayerPedId(), first_character.style)
        else
            model = GetHashKey(preview_ped)
            utils.requests.model(model)
            SetPlayerModel(PlayerId(), model)
            utils.character_creation.set_ped_appearance(PlayerPedId(), utils.shared.style[current_sex])
        end
        utils.requests.interior(GetInteriorAtCoords(DEFAULT_PED_LOCATION.x, DEFAULT_PED_LOCATION.y, DEFAULT_PED_LOCATION.z))
        utils.requests.collision(DEFAULT_PED_LOCATION.x, DEFAULT_PED_LOCATION.y, DEFAULT_PED_LOCATION.z)
        SetEntityCoords(PlayerPedId(), DEFAULT_PED_LOCATION.x, DEFAULT_PED_LOCATION.y, DEFAULT_PED_LOCATION.z, false, false, false, true)
        SetEntityHeading(PlayerPedId(), DEFAULT_PED_LOCATION.w)
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -0.05, 0.90, 0.45)
        if DoesCamExist(cam) then
            DestroyCam(cam, false)
        end
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(cam, true)
        SetCamCoord(cam, coords.x, coords.y, coords.z)
        SetCamRot(cam, 2.0, 0.0, DEFAULT_PED_LOCATION.w + 160)
        RenderScriptCams(true, false, 0, true, true)
        SetCamUseShallowDofMode(cam, true)
        SetCamNearDof(cam, 0.7)
        SetCamFarDof(cam, 1.3)
        SetCamDofStrength(cam, 1.0)
        SendNUIMessage({
            action = 'open_char_create',
            data = {
                values = utils.character_creation.get_clothing_and_prop_values(current_sex),
                characters = characters or {}
            }
        })
        Wait(500)
        DoScreenFadeIn(2000)
        while DoesCamExist(cam) do
            SetUseHiDof()
            Wait(0)
        end
    end)
end

--- Function to create a character with the given data.
-- Prepares character data and triggers a server event to create the character.
-- Includes identity, genetics, barber, tattoos, and clothing information.
-- @function create_character
-- @param data table: A table containing all the necessary character information.
-- @usage 
--[[
    create_character(data)
]]
-- @example
--[[
    local character_info = {
        first_name = "John",
        last_name = "Doe",
        sex = "male",
        dob = "1990-01-01",
        nationality = "United Kingdom",
        backstory = "A brief backstory."
    }
    create_character(character_info)
]]
local function create_character(data)
    if not data then
        debug_log('err', 'Function: create_character failed. | Reason: Incomplete character data provided.')
        return
    end
     
    local character_style = utils.shared.get_style(data.sex)
    local character_data = {
        char_id = data.char_id,
        identity = {
            first_name = data.first_name,
            last_name = data.last_name,
            sex = data.sex,
            dob = data.dob,
            nationality = data.nationality,
            backstory = data.backstory
        },
        style = character_style
    }
    TriggerServerEvent('boii:sv:create_character', table.clone(character_data))
end

-- Function to select a character and switch the view back from the camera.
-- Adjusts the player model based on character selection or initiates character creation preview.
-- @param data table: Contains details about the character or a flag indicating character creation.
local function select_character(data)
    if not data then
        debug_log('err', 'Function: select_character failed. | Reason: Data is missing or malformed.')
        return
    end
    local model
    if data.is_create_character then
        model = GetHashKey(preview_ped)
        utils.requests.model(model)
        SetPlayerModel(PlayerId(), model)
        utils.character_creation.set_ped_appearance(PlayerPedId(), utils.shared.style[current_sex])
    else
        current_sex = data.sex
        preview_ped = (current_sex == 'male') and 'mp_m_freemode_01' or 'mp_f_freemode_01'
        model = GetHashKey(preview_ped)
        utils.requests.model(model)
        SetPlayerModel(PlayerId(), model)
        utils.character_creation.set_ped_appearance(PlayerPedId(), data.style)
    end
end

--- Function to delete a character and trigger character creation setup.
-- Deletes a character by triggering a server event and reinitializes character creation.
-- Sets up the character creation process again after a character is deleted
-- @function delete_character
-- @param char_id number: The identifier of the character being deleted.
-- @usage 
--[[
    delete_character(char_id)
]]
-- @example
--[[
    delete_character(2)  -- Deletes the character with ID 2
]]
local function delete_character(char_id)
    if not char_id then
        debug_log('err', 'Function: delete_character failed. | Reason: Character ID is missing.')
        return
    end
    TriggerServerEvent('boii:sv:delete_character', char_id)
    setup_character_create()
end

--- Function to change camera position based on the given configuration.
-- Changes the camera to focus on the face, body, legs, or feet of the player's ped.
-- @function change_camera_position
-- @param value table: The configuration for the camera position.
-- @usage 
--[[
    change_camera_position(value)
]]
-- @example
--[[
    change_camera_position(CAMERA_POSITIONS['face_cam'])
    change_camera_position(CAMERA_POSITIONS['body_cam'])
]]
local function change_camera_position(value)
    if not value then
        debug_log('err', 'Function: change_camera_position failed. | Reason: Camera position parameter is missing.')
        return
    end
    local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), CAMERA_POSITIONS[value].offset.x, CAMERA_POSITIONS[value].offset.y, CAMERA_POSITIONS[value].offset.z)
    if DoesCamExist(cam) then
        DestroyCam(cam, false)
    end
    RenderScriptCams(false, false, 0, 1, 0)
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)
    SetCamCoord(cam, coords.x, coords.y, coords.z + CAMERA_POSITIONS[value].height_adjustment)
    SetCamRot(cam, 2.0, 0.0, DEFAULT_PED_LOCATION.w + 160)
    SetCamUseShallowDofMode(cam, true)
    SetCamNearDof(cam, CAMERA_POSITIONS[value].near_dof)
    SetCamFarDof(cam, CAMERA_POSITIONS[value].far_dof)
    SetCamDofStrength(cam, 1.0)
    while DoesCamExist(cam) do
        SetUseHiDof()
        Wait(0)
    end
end

--- @section NUI Callbacks

--- Callback for validating a player's name via NUI.
-- Triggers a server event to validate the player's name against the database.
-- @param data table: Contains the first_name and last_name to be validated.
-- @param cb function: Callback to NUI with the result.
-- @see validate_character_name (server-side function)
RegisterNUICallback('validate_name', function(data, cb)
    if not data or not data.first_name or not data.last_name then
        debug_log('err', 'NUI Callback: validate_name callback failed. | Reason: Incomplete name data provided.')
        return
    end
    utils.callback.cb('boii:sv:validate_character_name', { first_name = data.first_name, last_name = data.last_name }, function(is_valid)
        if is_valid then
            cb({ valid = is_valid })
        end
    end)
end)

--- Callback to send initial values of clothing and prop maximums.
-- @param data table: Data from NUI, can be empty for this callback.
-- @param cb function: Callback to NUI to confirm reception.
-- @see get_clothing_and_prop_values
RegisterNUICallback('get_clothing_max_values', function(data, cb)
    SendNUIMessage({
        action = 'clothing_and_prop_values',
        values = utils.character_creation.get_clothing_and_prop_values(current_sex)
    })
    if cb then
        cb('ok')
    end
end)

--- Callback to change the player's ped model.
-- @param data table: Contains the 'sex' key indicating the sex of the new ped model.
-- @param cb function: Callback to NUI to confirm the change.
-- @see change_player_ped
RegisterNUICallback('change_preview_ped_sex', function(data, cb)
    if not data or not data.sex then
        debug_log('err', 'NUI Callback: change_preview_ped_sex callback failed. | Reason: Incomplete sex data provided.')
        return
    end
    current_sex = data.sex
    utils.character_creation.set_ped_appearance(PlayerPedId(), utils.shared.style[current_sex])
    if cb then
        cb('ok')
    end
end)

--- Callback to rotate the ped.
-- @param data table: Contains the 'value' key indicating the direction and degree of rotation.
-- @param cb function: Callback to NUI to confirm the rotation.
-- @see rotate_ped
RegisterNUICallback('rotate_ped', function(data, cb)
    if not data or not data.value then
        debug_log('err', 'NUI Callback: rotate_ped callback failed. | Reason: Incomplete value data provided.')
        return
    end
    utils.character_creation.rotate_ped(data.value)
    if cb then
        cb('ok')
    end
end)

--- Callback to change the camera position.
-- @param data table: Contains the 'value' key indicating which camera position to switch to.
-- @param cb function: Callback to NUI to confirm the camera position change.
-- @see change_camera_position
RegisterNUICallback('change_camera_position', function(data, cb)
    if not data or not data.value then
        debug_log('err', 'NUI Callback: change_camera_position callback failed. | Reason: Incomplete value data provided.')
        return
    end
    change_camera_position(data.value)
    if cb then
        cb('ok')
    end
end)

--- Callback to load the character model with specific traits.
-- Validates the character data and triggers a function to load the character model with provided traits.
-- @param data table: Contains all the character information (identity, genetics, barber, clothing, tattoos).
-- @param cb function: Callback to NUI to confirm the model load.
-- @see load_character_model
RegisterNUICallback('load_character_model', function(data, cb)
    if not data then
        debug_log('err', 'NUI Callback: load_character_model callback failed. | Reason: Incomplete character data provided.')
        return
    end
    utils.character_creation.load_character_model(data)
    if cb then
        cb('ok')
    end
end)

--- Callback to set values for different character traits.
-- Validates the incoming data and updates ped data based on NUI callbacks.
-- @param data table: Contains the details of the trait to update (id, category, value).
-- @param cb function: Callback to NUI to confirm the value update.
-- @see update_ped_data
RegisterNUICallback('update_value', function(data, cb)
    if not data or not data.sex or not data.id or not data.category or not data.value then
        debug_log('err', 'NUI Callback: update_value callback failed. | Reason: Incomplete data provided.')
        return
    end
    utils.character_creation.update_ped_data(data.sex, data.category, data.id, data.value)
    update_clothing_values(data.sex)
    if cb then
        cb('ok')
    end
end)

--- Callback to create a character with the provided data.
-- Validates the character data and triggers a server event to create the character.
-- @param data table: Contains all the necessary character information.
-- @param cb function: Callback to NUI to confirm character creation.
-- @see create_character
RegisterNUICallback('create_character', function(data, cb)
    if not data then
        debug_log('err', 'NUI Callback: create_character callback failed. | Reason: Incomplete character data provided.')
        return
    end
    create_character(data)
    if cb then
        cb('ok')
    end
end)

--- Callback to select a character to load.
-- Validates the character ID and triggers a server event to load the selected character.
-- @param data table: Contains the 'char_id' of the character to be loaded.
-- @param cb function: Callback to NUI to confirm character selection.
-- @see select_character
RegisterNUICallback('select_character', function(data, cb)
    if not data then
        debug_log('err', 'NUI Callback: select_character callback failed. | Reason: Character Data is missing.')
        return
    end
    select_character(data)
    if cb then
        cb('ok')
    end
end)

--- Callback to delete a character.
-- Validates the character ID and triggers a server event to delete the character.
-- @param data table: Contains the 'char_id' of the character to be deleted.
-- @param cb function: Callback to NUI to confirm character deletion.
-- @see delete_character
RegisterNUICallback('delete_character', function(data, cb)
    if not data or not data.char_id then
        debug_log('err', 'NUI Callback: delete_character callback failed. | Reason: Character ID is missing.')
        return
    end
    delete_character(data.char_id)
    if cb then
        cb('ok')
    end
end)

--- Callback to enter server
-- Sends to server to create the player object before spawning
-- @param char_id: ID of the character to be loaded
RegisterNUICallback('play', function(data, cb)
    local char_id = data.char_id
    if not char_id then
        debug_log('err', 'NUI Callback: play callback failed. | Reason: Character ID is missing.')
        return
    end
    if DoesCamExist(cam) then
        SetCamActive(cam, false)
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(cam, false)
        cam = nil
    end
    SendNUIMessage({ action = 'close_char_creation' })
    SetNuiFocus(false, false)
    TriggerServerEvent('boii:sv:play', char_id)
    if cb then
        cb('ok')
    end
end)

--- Callback to disconnect
-- Triggers server event to drop player
RegisterNUICallback('disconnect', function(data, cb)
    TriggerServerEvent('boii:sv:drop_player')
    if cb then
        cb('ok')
    end
end)

--- @section Events

--- Event to initiate the character creation process.
-- Fades out the screen, sets up character creation, and then fades the screen back in.
-- @todo Ensure that the character creation setup is ready before fading back in.
RegisterNetEvent('boii:cl:open_character_create', function()
    DoScreenFadeOut(1000)
    Wait(2000)
    setup_character_create()
    DoScreenFadeIn(1000)
end)

--- Handler to initiate character creation once the player is spawned into the map.
-- Ensures the loading screen is shut down and character creation setup is initiated only once.
-- @see setup_character_create For the function that initializes character creation.
AddEventHandler('playerSpawned', function()
    if not load_screen and not first_spawn then
        ShutdownLoadingScreenNui()
        ShutdownLoadingScreen()
        setup_character_create()
        load_screen = true
        first_spawn = true
    end
end)