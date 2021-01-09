local Settings = require('__shared/settings')

if Settings.setup then
  return
end

Events:Subscribe('Partition:Loaded', function(partition)

  for _,v in pairs(partition.instances) do

    if v:Is('BFServerSettings') then
      local settings = BFServerSettings(v)
      settings:MakeWritable()
      settings.isKillerCameraEnabled = false
      settings.autoBalance = false
    end

  end

end)

local FULL_TEAM_DEATHMATCH = Guid('FAD987C1-7D2A-11E0-B283-C22E2A7B7393')
local FULL_TEAM_DEATHMATCH_BLUEPRINT = Guid('5E64B049-3FE1-8A8B-4D16-99435672C9BC')

ResourceManager:RegisterInstanceLoadHandler(FULL_TEAM_DEATHMATCH, FULL_TEAM_DEATHMATCH_BLUEPRINT, function(instance)

  local blueprint = SpatialPrefabBlueprint(instance)

  print('Spawn screen camera updated')
  local camera = CameraEntityData(blueprint.objects[4])
  camera:MakeWritable()
  camera.enabled = false

  print('Ticket counters disabled')
  local killCounter1 = KillCounterEntityData(blueprint.objects[20])
  killCounter1:MakeWritable()
  killCounter1.enabled = false

  local killCounter2 = KillCounterEntityData(blueprint.objects[21])
  killCounter2:MakeWritable()
  killCounter2.enabled = false

  local inputRestriction = InputRestrictionEntityData(blueprint.objects[41])
  inputRestriction:MakeWritable()
  inputRestriction.enabled = false

end)

local FULL_TEAM_DEATHMATCH_XP4 = Guid('676C0FD7-EA75-4F5D-8764-BB076F6F3E11')
local FULL_TEAM_DEATHMATCH_XP4_BLUEPRINT = Guid('5BB6F238-AB54-4EF4-B9E6-BADFD2290397')


ResourceManager:RegisterInstanceLoadHandler(FULL_TEAM_DEATHMATCH_XP4, FULL_TEAM_DEATHMATCH_XP4_BLUEPRINT, function(instance)

  local blueprint = SpatialPrefabBlueprint(instance)

  print('Spawn screen camera updated')
  local camera = CameraEntityData(blueprint.objects[4])
  camera:MakeWritable()
  camera.enabled = false

  print('Ticket counters disabled')
  local killCounter1 = KillCounterEntityData(blueprint.objects[20])
  killCounter1:MakeWritable()
  killCounter1.enabled = false

  local killCounter2 = KillCounterEntityData(blueprint.objects[21])
  killCounter2:MakeWritable()
  killCounter2.enabled = false

  local inputRestriction = InputRestrictionEntityData(blueprint.objects[41])
  inputRestriction:MakeWritable()
  inputRestriction.enabled = false

end)

local DEATHMATCH = Guid('57F399B3-70DD-11E0-9327-ED63059941A3')
local PREROUND = Guid('C328EFDC-AF70-4097-B47C-DF4C32E2EC3C')


ResourceManager:RegisterInstanceLoadHandler(DEATHMATCH, PREROUND, function(instance)

  print('Disabling preround')
  local preRound = PreRoundEntityData(instance)
  preRound:MakeWritable()
  preRound.enabled = false

end)

local MP_SOLDIER = Guid('F256E142-C9D8-4BFE-985B-3960B9E9D189')
local SOLDIER_BODY_COMPONENT = Guid('1C721510-AD42-4AFD-B613-04DC37D0FC1F')

ResourceManager:RegisterInstanceLoadHandler(MP_SOLDIER, SOLDIER_BODY_COMPONENT, function(instance)

  local soldierBodyComponentData = SoldierBodyComponentData(instance)

  soldierBodyComponentData:MakeWritable()

  soldierBodyComponentData.components:erase(13)
  print('Removing EntityInteractionComponent')


end)
