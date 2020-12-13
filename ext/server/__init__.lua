require('gunfight/equipment')
require('gunfight/gamesettings')
local Spawning = require('gunfight/spawning')
local Match = require('gunfight/match')
local Team = require('__shared/team')

local currentMatch = nil

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

NetEvents:Subscribe('Join', function(player, data)

  print('Join called')

  local team = nil

  if player.soldier ~= nil and player.soldier.isAlive then
    player.soldier:Kill()
  end

  if data == 'US' then
    team = Team.US
  elseif data == 'RU' then
    team = Team.RU
  else
    print('Invalid team specified')
    return
  end

  if currentMatch == nil then
    print('No match exists')
    return
  end

  currentMatch:Join(player, team)
  print('Player joined team ' .. team)
end)

NetEvents:Subscribe('Create', function(player, data)

  print('Create called')

  if currentMatch ~= nil then
    print('A match already exists')
    return
  end

  currentMatch = Match()
  print('Game created')

end)

NetEvents:Subscribe('Recreate', function(player, data)
  print('Recreate called')

  if currentMatch == nil then
    print('No match exists')
    return
  end

  currentMatch:stopMatch()
  currentMatch = Match()

end)

NetEvents:Subscribe('Destroy', function(player, data)

  print('Destroy called')

  if currentMatch == nil then
    print('No match exists')
    return
  end

  currentMatch:stopMatch()
  currentMatch = nil

end)

