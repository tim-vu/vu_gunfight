local Team = require('__shared/team')

local registerSetupCommands = function(config)

  NetEvents:Subscribe('Setup:Teleport', function(player, position)

    local soldier = player.soldier

    if not soldier then
      return
    end

    soldier:SetPosition(position)

  end)

  NetEvents:Subscribe('Command:Spawn', function(player, mapId, loadoutIndex)

    if mapId > #config.maps then
      print('Map nil')
    end

    local map = config.maps[mapId]
    local loadout = map.loadouts[loadoutIndex]

    if loadout == nil then
      print('Loadout nil')
      return
    end

    local soldier = player.soldier

    if soldier == nil then return end

    local transform = player.soldier.transform

    if soldier.isAlive then soldier:Kill() end

    Spawning.spawnSoldier(player, loadout, transform, Team.US)

  end)

end

return registerSetupCommands
