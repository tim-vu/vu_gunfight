require('gunfight/match')
require('setup/setup')
require('lobby')
require('__shared/common')

local applyUIModifications = require('gunfight/vanilla_ui')

Events:Subscribe('Gunfight:Initialize', function(config)
  print('Gunfight initializing, loading map: ' .. config.mapName)

  WebUI:Init()

  if config.setup then
    print('Setup mode enabled')
    Setup = Setup(config)
  else
    applyUIModifications()
    Lobby = Lobby()
    Match = Match()
  end

end)
