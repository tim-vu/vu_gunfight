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
local SPATIAL_PREFAB_BLUEPRINT = Guid('5E64B049-3FE1-8A8B-4D16-99435672C9BC')

local CAMERA_TRANSFORM = LinearTransform(
  Vec3(0, 0, 0),
  Vec3(0, 1, 0),
  Vec3(0, 0, 1),
  Vec3(0, 500, 0)
)

ResourceManager:RegisterInstanceLoadHandler(FULL_TEAM_DEATHMATCH, SPATIAL_PREFAB_BLUEPRINT, function(instance)

  local blueprint = SpatialPrefabBlueprint(instance)

  blueprint:MakeWritable()
  blueprint.propertyConnections:erase(1)

  local camera = CameraEntityData(blueprint.objects[4])

  camera:MakeWritable()
  camera.priority = 2
  camera.transform = CAMERA_TRANSFORM

  print('Spawn screen camera updated')
end)