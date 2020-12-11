Events:Subscribe('Level:Loaded', function(levelName, gameMode, round, roundsPerMap)

  local sett = ResourceManager:GetSettings('SyncedBFSettings');

  local settings = SyncedBFSettings(sett)

  settings.noMinimap = true

  print('Disabled minimap')

end)