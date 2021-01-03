require('gunfight/match')
local Lobby = require('lobby')

local RemoveDefaultUI = require('gunfight/vanilla_ui')
local Commands = require('commands')
local Settings = require('__shared/settings')

RemoveDefaultUI(Settings.setup)

if Settings.setup then

  print('Setup mode enabled')

  Commands.registerSetupCommands()

else

  local lobby = Lobby()

  Commands.registerLobbyCommands(lobby)

end
