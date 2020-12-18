Events:Subscribe('Level:Loaded', function(levelName, gameMode, round, roundsPerMap)

  local sett = ResourceManager:GetSettings('SyncedBFSettings');

  local settings = SyncedBFSettings(sett)

  settings.noMinimap = true
  settings.teamSwitchingAllowed = false
  settings.no3dSpotting = true

end)