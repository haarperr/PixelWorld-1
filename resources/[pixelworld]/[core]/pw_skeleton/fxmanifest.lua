description 'PixelWorld Skeleton'
name 'PixelWorld pw_skeleton'
author 'PixelWorldRP [creaKtive] - https://pixelworldrp.com'
version 'v1.0.0'

client_scripts {
	'config.lua',
	'client/wound.lua',
	'client/main.lua',
	'client/items.lua',
}

server_scripts {
	'@pw_mysql/lib/MySQL.lua',
	'server/wound.lua',
	'server/main.lua',
}

dependencies {
	'pw_core',
	'pw_progbar',
	'pw_notify',
}

server_exports {
    'GetCharsInjuries',
}

fx_version 'bodacious'
games {'gta5'}