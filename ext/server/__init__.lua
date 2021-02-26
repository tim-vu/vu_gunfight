local Lobby = require('lobby')
local registerSetupCommands = require('commands')
local version = require('version')

local VERSION_URL =
    'https://raw.githubusercontent.com/tim-vu/vu_gunfight/master/mod.json'

local printOutOfDateMessage = function()
  print('================================================')
  print('You are running an outdated version of Gunfight!')
  print('================================================')
end

ServerUtils:SetCustomGameModeName('Gunfight')

local response = Net:GetHTTP(VERSION_URL)

if response == nil then
  print('Unable to check for updates')
else
  local latestVersion = json.decode(response.body).Version

  if latestVersion > version then
    printOutOfDateMessage()
    printOutOfDateMessage()
    printOutOfDateMessage()
  else
    print('Up to date')
  end

end

print('Waiting for initialization')
Events:Subscribe('Gunfight:Initialize', function(config)
  print('Gunfight initializing, loading map: ' .. config.mapName)
  ServerUtils:SetCustomMapName(config.mapName)

  if config.setup then
    print('Setup mode enabled')
    registerSetupCommands(config.maps)
  else
    print('Setup mode disabled, starting the lobby')
    Lobby(config.maps)
  end

end)

