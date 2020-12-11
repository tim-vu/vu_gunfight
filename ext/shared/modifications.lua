local MP_SOLDIER = Guid('F256E142-C9D8-4BFE-985B-3960B9E9D189')
local SOLDIER_BODY_COMPONENT = Guid('1C721510-AD42-4AFD-B613-04DC37D0FC1F')

Events:Subscribe('Partition:Loaded', function(partition)

  if partition.guid == MP_SOLDIER then

    for _,v in pairs(partition.instances) do

      if v.instanceGuid == SOLDIER_BODY_COMPONENT then

        local soldierBodyComponentData = SoldierBodyComponentData(v)

        soldierBodyComponentData:MakeWritable()

        soldierBodyComponentData.components:erase(13)

        print('Removing EntityInteractionComponent')

      end

    end

  end

end)