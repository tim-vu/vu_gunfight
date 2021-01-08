require('gunfight/match')
require('gunfight/vanilla_ui')

local Lobby = require('lobby')
local Commands = require('commands')
local Settings = require('__shared/settings')

if Settings.setup then

  print('Setup mode enabled')

  Commands.registerSetupCommands()

else

  local lobby = Lobby()

  Commands.registerLobbyCommands(lobby)

end