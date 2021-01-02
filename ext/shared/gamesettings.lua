Events:Subscribe('Partition:Loaded', function(partition)

  for _,v in pairs(partition.instances) do

    if v:Is('SyncedGameSettings') then
      local settings = SyncedGameSettings(v)
      settings:MakeWritable()
      settings.disableRegenerateHealth = true
    end

  end

end)