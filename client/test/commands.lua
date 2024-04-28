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

-- Function to copy coords
local function copy_coords()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local x = utils.maths.round(coords.x, 2)
    local y = utils.maths.round(coords.y, 2)
    local z = utils.maths.round(coords.z, 2)
    local heading = GetEntityHeading(ped)
    local h = utils.maths.round(heading, 2)
    SendNUIMessage({
        action = 'copy_to_clipboard', 
        string = string.format('vector4(%s, %s, %s, %s)', x, y, z, h)
    })
    utils.ui.notify({
        header = 'DEVELOPER',
        message = 'Copied v4 coords!',
        type = 'success',
        duration = 2000
    })
end

RegisterCommand('copycoords', function()
    copy_coords()
end)
