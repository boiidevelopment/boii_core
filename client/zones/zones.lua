
--- @section Tables

--- Safe zones
local safe_zones = {
    {
        id = "safe_zone_1",
        type = "circle",
        center = vector3(200.0, 200.0, 30.0),
        radius = 50.0,
        debug = true,
        rules = {
            no_weapons = true
        }
    },
    {
        id = "test_box_zone",
        type = 'box',
        icon = "fa-solid fa-square",
        coords = vector3(-241.74, -990.81, 29.29),
        width = 3,
        height = 3,
        depth = 3,
        heading = 45,
        debug = true,
        rules = {
            no_weapons = true
        }
    }
}

--- @section Local functions

--- Checks safe zone rules.
-- @param point: vector3 coords to check.
local function check_safe_zone_rules(point)
    local zones = utils.zones.get_zones()
    for id, zone in pairs(safe_zones) do
        if zone.rules.no_weapons and utils.zones.is_in_zone(point) then
            DisableControlAction(1, 24, true) -- disable attack
            DisableControlAction(1, 25, true) -- disable aim
            DisableControlAction(1, 140, true) -- disable melee
            DisableControlAction(1, 141, true) -- disable melee
            DisableControlAction(1, 142, true) -- disable melee
            SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
            RemoveAllPedWeapons(PlayerPedId(), true)
            current_weapon = nil
            return true
        end
    end
    return false
end

--- Initilizes safe_zones.
local function initialize_safe_zones()
    for _, zone in ipairs(safe_zones) do
        if zone.type == 'box' then
            utils.zones.add_box(zone)
        end
        if zone.type == 'circle' then
            utils.zones.add_circle(zone)
        end
    end
end
initialize_safe_zones()

--- @section Threads

--- Checks if a player is a inside a safezone.
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(PlayerPedId())
        local in_safe_zone = check_safe_zone_rules(coords)
        if in_safe_zone then
            print("You are in a safe zone.")
        end
        Wait(1000)
    end
end)