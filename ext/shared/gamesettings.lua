--[[ Events:Subscribe('Partition:Loaded', function(partition)

  for _,v in pairs(partition.instances) do

    if v:Is('SyncedGameSettings') then
      local settings = SyncedGameSettings(v)
      settings:MakeWritable()
      settings.disableRegenerateHealth = true
    end

  end

end) ]]

Events:Subscribe('Level:Loaded', function(levelName, gameMode, round, roundsPerMap)

  local settings = SyncedBFSettings(ResourceManager:GetSettings('SyncedBFSettings'));

  settings.noMinimap = true
  settings.teamSwitchingAllowed = false
  settings.no3dSpotting = true

  settings = SyncedGameSettings(ResourceManager:GetSettings('SyncedGameSettings'))
  settings.disableRegenerateHealth = true

end)