fx_version "cerulean"

author "CanX"
version '1.0.0'

lua54 'yes'

games {
  "gta5"
}

ui_page 'web/build/index.html'

shared_scripts {
  'shared/config.lua'
}

client_script {
  "client/**/*"
}

server_script {
  '@mysql-async/lib/MySQL.lua',
  "server/**/*"
}

files {
  'web/build/index.html',
  'web/build/**/*',
}
