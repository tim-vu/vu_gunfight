require('gunfight/vanilla_ui')
require('gunfight/deathcam')
require('gunfight/match')

Console:Register('spawn', 'Spawns the player', function(args) NetEvents:Send('Spawn') end)

Console:Register('join', 'Joins a given team', function(args)

  if #args ~= 1 then 
    return 'Invalid number of arguments specified'
  end

  NetEvents:Send('Join', args[1])

end)

Console:Register('transform', "Prints the player's current transform", function(args)
  local player = PlayerManager:GetLocalPlayer()

  if player.soldier == nil or not player.soldier.isAlive then
    return 'The player is currently not alive'
  end

  local transform = player.soldier.transform

  return string.format('LinearTransform(\n  Vec3%s,\n  Vec3%s,\n  Vec3%s,\n  Vec3%s\n)',
    transform.left,
    transform.up,
    transform.forward,
    transform.trans
  )

end)

Console:Register('position', "Prints the player's current position", function(args)

  local player = PlayerManager:GetLocalPlayer()

  if player.soldier == nil or not player.soldier.isAlive then
    return 'The player is current not alive'
  end

  local transform = player.soldier.transform

  return string.format('Vec3%s',transform.trans)
end)

Console:Register('team', "Prints the player's current team", function(args)
  local player = PlayerManager:GetLocalPlayer()

  return tostring(player.teamId)
end)

Console:Register('create', 'Create a new gunfight match', function(args)
  NetEvents:Send('Create')
end)

Console:Register('recreate', 'Destroy the current match and create a new one', function(args)
  NetEvents:Send('Recreate')
end)

Console:Register('destroy', 'Destroys the current gunfight match', function(args)
  NetEvents:Send('Destroy')
end)

Events:Subscribe('Partition:Loaded', function(partition)
  for _, instance in pairs(partition.instances) do

    if instance:Is('DofComponentData') then

      local instance = DofComponentData(instance)
      instance:MakeWritable()
      --instance.enabled = false

    end

    if instance:Is('ColorCorrectionComponentData') then

      local s_Instance = ColorCorrectionComponentData(instance)
      s_Instance:MakeWritable()
      s_Instance.enable = false
      s_Instance.brightness = Vec3(1, 1, 1)
      s_Instance.contrast = Vec3(1.2, 1.2, 1.2)
      s_Instance.saturation = Vec3(1, 1, 1)

    end

    if instance.instanceGuid == Guid('9CDAC6C3-9D3E-48F1-B8D9-737DB28AE936') then -- menu UI/Assets/MenuVisualEnvironment     

      local s_Instance = ColorCorrectionComponentData(instance)
      s_Instance:MakeWritable()
      s_Instance.enable = false
      s_Instance.brightness = Vec3(1, 1, 1)
      s_Instance.contrast = Vec3(1.2, 1.2, 1.2)
      s_Instance.saturation = Vec3(1, 1, 1)

    end

    if instance.instanceGuid == Guid('46FE1C37-5B7E-490C-8239-2EB2D6045D7B') then -- oob FX/VisualEnviroments/OutofCombat/OutofCombat
      local s_Instance = ColorCorrectionComponentData(instance)
      s_Instance:MakeWritable()
      s_Instance.enable = false
      s_Instance.brightness = Vec3(0.8, 0.8, 0.8)
      s_Instance.contrast = Vec3(1, 1, 1)
      s_Instance.saturation = Vec3(1, 1, 1)
    end

    if instance.instanceGuid == Guid('36C2CEAE-27D2-45F3-B3F5-B831FE40ED9B') then -- FX/VisualEnviroments/OutofCombat/OutofCombat
      local s_Instance = FilmGrainComponentData(instance)
      s_Instance:MakeWritable()
      s_Instance.enable = false
    end

  end
end)