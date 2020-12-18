local MP_SOLDIER = Guid('F256E142-C9D8-4BFE-985B-3960B9E9D189')
local SOLDIER_BODY_COMPONENT = Guid('1C721510-AD42-4AFD-B613-04DC37D0FC1F')
local MENU_VISUAL_ENVIRONMENT = Guid('9CDAC6C3-9D3E-48F1-B8D9-737DB28AE936')
local OUT_OF_COMBAT_COLOR_CORRECT = Guid('46FE1C37-5B7E-490C-8239-2EB2D6045D7B')
local OUT_OF_COMBAT_FILM_GRAIN = Guid('36C2CEAE-27D2-45F3-B3F5-B831FE40ED9B')

Events:Subscribe('Partition:Loaded', function(partition)

  if partition.guid == MP_SOLDIER then

    for _,v in pairs(partition.instances) do

      if v.instanceGuid == SOLDIER_BODY_COMPONENT then

        local soldierBodyComponentData = SoldierBodyComponentData(v)

        soldierBodyComponentData:MakeWritable()

        soldierBodyComponentData.components:erase(13)

      end

      if v:Is('DofComponentData') then

        local instance = DofComponentData(instance)
        instance:MakeWritable()
        instance.enabled = false
      end

      if v:Is('ColorCorrectionComponentData') then

        local instance = ColorCorrectionComponentData(instance)
        instance:MakeWritable()
        instance.enable = false
        instance.brightness = Vec3(1, 1, 1)
        instance.contrast = Vec3(1.2, 1.2, 1.2)
        instance.saturation = Vec3(1, 1, 1)

      end

      if v.instanceGuid == MENU_VISUAL_ENVIRONMENT then

        local instance = ColorCorrectionComponentData(instance)
        instance:MakeWritable()
        instance.enable = false
        instance.brightness = Vec3(1, 1, 1)
        instance.contrast = Vec3(1.2, 1.2, 1.2)
        instance.saturation = Vec3(1, 1, 1)

      end

      if v.instanceGuid == OUT_OF_COMBAT_COLOR_CORRECT then
        local instance = ColorCorrectionComponentData(instance)
        instance:MakeWritable()
        instance.enable = false
        instance.brightness = Vec3(0.8, 0.8, 0.8)
        instance.contrast = Vec3(1, 1, 1)
        instance.saturation = Vec3(1, 1, 1)
      end

      if v.instanceGuid == OUT_OF_COMBAT_FILM_GRAIN then
        local instance = FilmGrainComponentData(instance)
        instance:MakeWritable()
        instance.enable = false
      end

    end

  end

end)