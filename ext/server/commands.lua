local Maps = require('__shared/maps')
local Team = require('__shared/team')

local registerSetupCommands = function()

  NetEvents:Subscribe('Command:Spawn', function(player, mapId, loadoutIndex)

    local map = Maps[mapId]
    local loadout = map.loadouts[loadoutIndex]

    if loadout == nil then
      print('Loadout nil')
      return
    end

    local soldier = player.soldier

    if soldier == nil then

      Spawning.spawnSoldier(player, loadout,
      LinearTransform(
        Vec3(1, 0, 0),
        Vec3(0, 1, 0),
        Vec3(0, 0, 1),
        Vec3(-354.525391, 70.436325, 245.196289)
      ), Team.US)
      return
    end

    local transform = player.soldier.transform

    if soldier.isAlive then
      soldier:Kill()
    end

    Spawning.spawnSoldier(player, loadout, transform, Team.US)

  end)

end

return registerSetupCommands