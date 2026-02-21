fx_version 'cerulean'
games { 'gta5' }
author 'CCP (CarCenterPerformance)'
description 'A Simple NativeUI Shop'
version '1.0.0'

shared_scripts {
    'config.lua'
}
client_scripts {
    '@NativeUI/NativeUI.lua',
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}