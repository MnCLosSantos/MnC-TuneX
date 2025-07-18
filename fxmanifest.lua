fx_version 'cerulean'
games { 'gta5' }
author 'MnC Los Santos'

dependency 'oxmysql'


client_scripts {
    'client/*'
}

server_scripts {
    'server/*'
}

shared_scripts {
    '@ox_lib/init.lua',
	'@oxmysql/lib/MySQL.lua',
    'config.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
}

ui_page 'html/index.html'

lua54 'yes'
