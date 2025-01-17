fx_version 'bodacious'
games {'gta5'} -- 'gta5' for GTAv / 'rdr3' for Red Dead 2, 'gta5','rdr3' for both

description 'PixelWorld Ped Features'
name 'PixelWorld: pw_pedfeatures'
author 'PixelWorldRP creaKtive - https://pixelworldrp.com'
version 'v1.0.0'

server_scripts {
    '@pw_mysql/lib/MySQL.lua', -- Required for MySQL Support
    'config/config.lua',
    'server/main.lua',
}

client_scripts {
    'config/config.lua',
    'client/main.lua',
}

dependencies {
    'pw_mysql',
    'pw_notify',
    'pw_interact',
    'pw_progbar',
    'pw_core'
}