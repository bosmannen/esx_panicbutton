fx_version 'cerulean'
game 'gta5'

author '[HVRP]Bosmannen'
description 'noodknop'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

files {
    'html/index.html',
    'sounds/noodknop.wav' -- Ensure this path points to your sound file
}

ui_page 'html/index.html' -- The HTML page for the NUI

dependency 'ox_lib'