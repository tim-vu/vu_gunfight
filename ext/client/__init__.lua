require('gunfight/match')

local Lobby = require('lobby')
local Commands = require('commands')
local applyUIModifications = require('gunfight/vanilla_ui')

Events:Subscribe('Gunfight:Initialize', function(config)
  print('Gunfight initializing, loading map: ' .. config.mapName)

  if config.setup then
    print('Setup mode enabled')
    Commands.registerSetupCommands()
  else
    applyUIModifications()
    Lobby = Lobby()
    Commands.registerLobbyCommands(Lobby)
  end

end)
