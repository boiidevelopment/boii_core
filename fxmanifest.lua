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

fx_version 'cerulean'
game { 'gta5' }

name 'boii_core'
version '0.1.0'
description 'BOII | Development - FiveM Framework Base'
author 'boiidevelopment'
repository 'https://github.com/boiidevelopmet/boii_core'
lua54 'yes'

ui_page 'html/index.html'

files {
    'html/**/**/**/**',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/config.lua',
    'server/init.lua',
    'server/database.lua',
    'server/player/player_data.lua',
    'server/player/player.lua',
    'server/player/player_object.lua',
    'server/player/connections.lua',
    'server/characters/creation.lua',
    'server/banking/banking.lua',
    'server/stores/stores.lua',
    'server/commands/commands.lua',
    'server/exports.lua',
    'server/test/commands.lua'
}

client_scripts {
    'client/config.lua',
    'client/init.lua',
    'client/player/player.lua',
    'client/characters/creation.lua',
    'client/inventory/inventory.lua',
    'client/dialogues/dialogues.lua',
    'client/banking/banking.lua',
    'client/stores/stores.lua',
    'client/commands/commands.lua',
    'client/actionmenu/action_menu.lua',
    'client/exports.lua',
    'client/test/commands.lua'
}

shared_scripts {
    'shared/init.lua',
    'shared/data/*'
}

escrow_ignore {
    'shared/**/*',
    'server/**/*',
    'client/**/*',
}