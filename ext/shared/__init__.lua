require('__shared/gamesettings')

local applyModifications = require('__shared/modifications')

Events:Subscribe('Gunfight:Initialize', function(config)
  applyModifications(config)
end)

