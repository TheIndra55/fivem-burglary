fx_version 'adamant'

game 'gta5'

shared_scripts {
	'@es_extended/imports.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua',
	'config.lua'
}

client_scripts {
	'client.lua'
}