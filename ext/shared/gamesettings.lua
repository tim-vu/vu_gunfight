Events:Subscribe('Level:Loaded', function(levelName, gameMode)

  local settings = SyncedBFSettings(ResourceManager:GetSettings('SyncedBFSettings'));
  settings.noMinimap = true
  settings.teamSwitchingAllowed = false
  settings.no3dSpotting = true

  settings = SyncedGameSettings(ResourceManager:GetSettings('SyncedGameSettings'))
  settings.disableRegenerateHealth = true

end)