require('__shared/common.lua')
require('timer')
local Status = require('gunfight/status')
local Spawning = require('gunfight/spawning')
local Equipment = require('gunfight/equipment')
local MapData = require('__shared/mapdata')
local Team = require('__shared/team')

local Match = class('Match')

Match.static.TEAMS = 2
Match.static.TEAM_SIZE = 1
Match.static.ROUNDS = 10
Match.static.PREGAME_WAIT_DURATION = 2
Match.static.ROUND_ENDED_WAIT_DURATION = 2
Match.static.ROUND_ENDED_MOVEMENT_DURATION = 1.5
Match.static.PREROUND_WAIT_DURATION = 3
Match.static.POST_MATCH_DURATION = 3
Match.static.ROUNDS_PER_SIDE = 2

function Match:__init()
  self.players = { }
  self.scores = {
    [Team.US] = 0,
    [Team.RU] = 0
  }
  self.status = Status.NOT_STARTED
  self.timestamp = 0
  self.round = 1
  self.loadouts = { }
  self.map = MapData.NOSHAR_CANALS

  self._playerLeftEvent = Events:Subscribe('Player:Left', self, self._onPlayerLeft)
  self._playerKilledEvent = Events:Subscribe('Player:Killed', self, self._onPlayerKilled)
  self._soldierDamageHook = Hooks:Install('Soldier:Damage', 1, self, self._onDamageDealt)

end

function Match:Join(player, team)

  if self.status ~= Status.NOT_STARTED then
    NetEvents:SendTo('Match:JoinFailed', 'The game you tried to join is already in progress')
    return
  end

  local teamPlayerCount = #self:_getPlayersByTeam(team)

  if teamPlayerCount >= Match.TEAM_SIZE then
    NetEvents:SendTo('Match:JoinFailed', player, 'The team you tried to join is full')
    print('Team full')
    return
  end

  --Make sure the player is in the correct team
  local teamId = GetTeamId(team)

  if player.teamId ~= teamId then
    player.teamId = team
  end

  self.players[player.id] = { id = player.id, name = player.name, team = team, alive = true }

  NetEvents:SendTo('Match:Joined', player, team)

  if GetCount(self.players) == Match.TEAMS * Match.TEAM_SIZE then
    print('Enough players, starting game')
    self:_initializeLoadouts()

    local playersArray = {}

    for _, v in pairs(self.players) do
      table.insert(playersArray, v)
    end

    self:_sendToPlayers('Match:Starting', playersArray)

    SetTimeout(function()
      print('Pregame wait over, preparing round')
      self:_prepareRound()
    end, Match.PREGAME_WAIT_DURATION)

    self.status = Status.PREGAME_WAIT
  end

end

function Match:_initializeLoadouts()

  for i=1,Match.ROUNDS,1 do
    local loadout = Equipment.LOADOUTS[math.random(#Equipment.LOADOUTS)]
    self.loadouts[i] = loadout
  end

  print('Loadouts: ' .. tostring(self.loadouts))

end

function Match:_getPlayersByTeam(team)

  local players = { }

  for _,v in pairs(self.players) do

    if v.team == team then
      table.insert(players, v)
    end

  end

  return players

end

function Match:_prepareRound()

  print('Round is being prepared')

  self:toggleInput(false)

  local indices = {
    [Team.US] = 1,
    [Team.RU] = 1
  }

  local loadout = self.loadouts[self.round]

  for k,p in pairs(self.players) do

    local player = PlayerManager:GetPlayerById(k)

    if player == nil then
      print(string.format('Unable to find player with id %d, stopping the game', k))
      self:stopMatch()
      return
    end

    local soldier = player.soldier
    if soldier ~= nil and soldier.isAlive then
        print('Killing soldier')
        soldier:Kill()
    end

  end

  for k,p in pairs(self.players) do

    local player = PlayerManager:GetPlayerById(k)

    if player == nil then
      print(string.format('Unable to find player with id %d, stopping the game', k))
      self:stopMatch()
      return
    end

    local spawnpoints = self:_getSpawnPoints(self.round, p.team, self.map.spawnpoints)
    Spawning.spawnSoldier(player, loadout, spawnpoints[indices[p.team]], p.team)

    indices[p.team] = indices[p.team] + 1

  end

  self:_cleanupMap()

  if not self:_sendToPlayers('Round:Starting', loadout) then
    self:stopMatch()
    return
  end

  SetTimeout(function()
    print('Preround wait over, starting roud')
    self:startRound()
  end, Match.PREROUND_WAIT_DURATION)

  self.status = Status.PREROUND_WAIT
end

function Match:_getSpawnPoints(round, team, spawnpoints)

  local div = (round - 1) // Match.ROUNDS_PER_SIDE

  if team == Team.US then
    return div % 2 == 0 and spawnpoints.A or spawnpoints.B
  end

  return div % 2 == 0 and spawnpoints.B or spawnpoints.A

end

function Match:_cleanupMap()

  self:_removeEntities('ServerPickupEntity')
  self:_removeEntities('ServerSoldierEntity', function(entity)
    local soldier = SoldierEntity(entity)
    return not soldier.isAlive
  end)

end

function Match:_removeEntities(type, predicate)

  local it = EntityManager:GetIterator(type)

  local entity = it:Next()
  
  while entity ~= nil do

    local spatialEntity = SpatialEntity(entity)

    local x = spatialEntity.transform.trans.x
    local y = spatialEntity.transform.trans.z

    if (not predicate or predicate(entity)) and self.map.area:IsInside(x, y) then
      entity:Destroy()
    end

    entity = it:Next()
  end

end

function Match:startRound()

  if not self:_sendToPlayers('Round:Started') then
    self:stopMatch()
    return
  end

  print('Round is started')

  self:toggleInput(true)
  self.status = Status.ROUND_IN_PROGRESS
end

local INPUT_ACTIONS = {
  EntryInputActionEnum.EIAStrafe,
  EntryInputActionEnum.EIAJump,
  EntryInputActionEnum.EIAFire,
  EntryInputActionEnum.EIASprint,
  EntryInputActionEnum.EIAProne,  
  EntryInputActionEnum.EIAThrottle,
  EntryInputActionEnum.EIABrake
}

function Match:toggleInput(enabled)

  for k,_ in pairs(self.players) do

    local player = PlayerManager:GetPlayerById(k)

    if player == nil then
      print(string.format('Unable to find find player with id %d, stopping the game', k))
      self:stopMatch()
      return
    end

    for _,v in pairs(INPUT_ACTIONS) do
      player:EnableInput(v, enabled)
    end

  end

end

function Match:stopMatch()

  if self.status == Status.MATCH_ENDED then
    return
  end

  self:_sendToPlayers('Match:Ended')

  self.players = { }

  self._playerLeftEvent:Unsubscribe()
  self._playerKilledEvent:Unsubscribe()
  self._soldierDamageHook:Uninstall()

  self.status = Status.MATCH_ENDED
  print('Match stopped')

end

function Match:_onPlayerKilled(player)

  if self.status ~= Status.ROUND_IN_PROGRESS then
    return
  end

  local p = self.players[player.id]

  if p == nil then
    return
  end

  p.alive = false

  local teamPlayers = self:_getPlayersByTeam(p.team)

  for _,v in pairs(teamPlayers) do

    if v.alive then
      --team is not dead
      return
    end

  end

  -- team is ded

  for k,v in pairs(self.scores) do

    if k ~= p.team then
      self.scores[k] = v + 1
    end

  end

  if self.scores[Team.US] == Match.ROUNDS / 2 and self.scores[Team.RU] == Match.ROUNDS / 2 then

    if not self:_sendToPlayers('Match:Draw') then
      self:stopMatch()
      return
    end

    SetTimeout(function()
      print('Postmatch wait over, stopping match')

      self:stopMatch()
    end, Match.POST_MATCH_DURATION)

    self.status = Status.MATCH_ENDED_WAIT
    return
  end

  for k,v in pairs(self.scores) do

    if v > Match.ROUNDS / 2 then

        if not self:_sendToPlayers('Match:Completed', k) then
          self:stopMatch()
          return
        end

        SetTimeout(function()
          print('Postmatch wait over, stopping match')
    
          self:stopMatch()
        end, Match.POST_MATCH_DURATION)

        self.status = Status.MATCH_ENDED_WAIT

      return
    end

  end

  SetTimeout(function()
    self:toggleInput(false)
  end, Match.ROUND_ENDED_MOVEMENT_DURATION)

  if not self:_sendToPlayers('Round:Completed', GetOtherTeam(p.team)) then
    self:stopMatch()
    return
  end

  self.round = self.round + 1
  self.status = Status.ROUND_ENDED

  SetTimeout(function()
    print('Postround wait over, starting round')
    self:_prepareRound()
  end, Match.ROUND_ENDED_WAIT_DURATION)

end

function Match:_onPlayerLeft(player)

  local p = self.players[player.id]

  if p == nil then
    return
  end

  self.players[k] = nil
  self:stopMatch()

end

function Match:_onDamageDealt(hook, soldier, info, giverInfo)

  if self.status == Status.ROUND_IN_PROGRESS then

    self:_sendToPlayers('Damage:Dealt', {
      giverId =  giverInfo.giver ~= nil and giverInfo.giver.id or nil,
      receiverId = soldier.player.id,
      amount = math.min(soldier.health, info.damage)
    })

  end

end

function Match:_sendToPlayers(eventName, args)

  local players = {}

  for k,_ in pairs(self.players) do

    local player = PlayerManager:GetPlayerById(k)

    if player == nil then
      return false
    end

    table.insert(players, player);

  end

  for _,v in pairs(players) do
    NetEvents:SendTo(eventName, v, args)
  end

  return true

end 

return Match