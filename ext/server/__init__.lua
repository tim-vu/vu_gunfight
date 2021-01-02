local Lobby = require('lobby')
local Settings = require('__shared/settings')
local Maps = require('__shared/maps')
local registerSetupCommands = require('commands')
local version = require('version')

local VERSION_URL = 'https://raw.githubusercontent.com/tim-vu/vu_gunfight/master/mod.json'

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


if Settings.setup then
  print('Setup mode enabled')
  registerSetupCommands()
else
  Lobby(Maps)
end


