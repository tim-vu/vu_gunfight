require('gunfight/equipment')
require('gunfight/gamesettings')

local Lobby = require('lobby')
local Spawning = require('gunfight/spawning')
local Team = require('__shared/team')
local Settings = require('__shared/settings')
local Maps = require('__shared/maps')

if Settings.setup then
  print('Setup mode enabled')
else
  Lobby(Maps)
end

NetEvents:Subscribe('Spawn', function(player)

  local loadout = LOADOUTS[1]

  local soldier = player.soldier

  if soldier == nil then

    -- Update position
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