require('__shared/common.lua')
require('__shared/timer')

local Spawning = require('gunfight/spawning')
local Team = require('__shared/team')
local Status = require('__shared/status')

local Match = class('Match')

Match.static.TEAMS = 2
Match.static.ROUNDS = 11
Match.static.PREGAME_WAIT_DURATION = 2
Match.static.POSTROUND_WAIT_DURATION = 3
Match.static.ROUND_ENDED_MOVEMENT_DURATION = 1.5
Match.static.PREROUND_WAIT_DURATION = 5
Match.static.POST_MATCH_DURATION = 5
Match.static.ROUNDS_PER_SIDE = 2

function Match:__init(mapId, map)
  self.players = { }
  self.scores = {
    [Team.US] = 0,
    [Team.RU] = 0
  }
  self.status = Status.NOT_STARTED
  self.round = 1
  self.loadouts = { }
  self.mapId = mapId

  self.map = map

  self._playerLeftEvent = Events:Subscribe('Player:Left', self, self.Leave)
  self._playerKilledEvent = Events:Subscribe('Player:Killed', self, self._onPlayerKilled)
  self._soldierDamageHook = Hooks:Install('Soldier:Damage', 1, self, self._onDamageDealt)

end

function Match:IsFull()
  return GetCount(self.players) >= self.map.teamSize * Match.TEAMS
end

function Match:IsTeamFull(team)

  local playerCount = 0

  for _,v in pairs(self.players) do

    if v.team == team then
      playerCount = playerCount + 1
    end

  end

  return playerCount >= self.map.teamSize

end

function Match:Join(player, team)

  if self.status ~= Status.NOT_STARTED then
    return false, 'The game you tried to join is already in progress'
  end

  if self.players[player.id] ~= nil then
    return false, 'You have already joined this match'
  end

  local teamPlayerCount = #self:_getPlayersByTeam(team)

  if teamPlayerCount >= self.map.teamSize then
    return false, 'The team you tried to join is full'
  end

  local teamId = GetTeamId(team)

  if player.teamId ~= teamId then
    player.teamId = team
  end

  self.players[player.id] = { name = player.name, id = player.id, team = team, alive = true }

  NetEvents:SendTo('Match:Joined', player, team)

  if GetCount(self.players) == Match.TEAMS * self.map.teamSize then
    print('Enough players, starting game')
    self:_initializeLoadouts()

    local playersArray = {}

    for _, v in pairs(self.players) do
      table.insert(playersArray, v)
    end

    self:_sendToPlayers('Match:Starting', self.map.displayName, self.map.teamSize, playersArray)

    self._pregameWaitTimeout = SetTimeout(function()
      print('Pregame wait over, preparing round')
      self:_prepareRound()
    end, Match.PREGAME_WAIT_DURATION)

    self:_updateStatus(Status.PREGAME_WAIT)
  end

  return true

end

function Match:Leave(player)

  local p = self.players[player.id]

  if p == nil then
    return
  end

  self.players[player.id] = nil

  if self.status == Status.NOT_STARTED then
    Events:Dispatch('Match:PlayerLeft', self.mapId, p.id)
    return
  end

  print('Stopping match as someone left')
  self:stopMatch()

end

function Match:_initializeLoadouts()

  for i=1,Match.ROUNDS,1 do
    local loadout = self.map.loadouts[math.random(#self.map.loadouts)]
    self.loadouts[i] = loadout
  end
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

function Match:_updateStatus(status)
  self.status = status
  Events:Dispatch('Match:StatusChanged', self.mapId, status)
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

    p.alive = true

    local spawnpoints = self:_getSpawnPoints(self.round, p.team, self.map.spawnpoints)
    Spawning.spawnSoldier(player, loadout, spawnpoints[indices[p.team]], p.team)

    indices[p.team] = indices[p.team] + 1

  end

  self:_cleanupMap()

  if not self:_sendToPlayers('Round:Starting', loadout) then
    self:stopMatch()
    return
  end

  self._preroundWaitTimeout = SetTimeout(function()
    print('Preround wait over, starting roud')
    self:startRound()
  end, Match.PREROUND_WAIT_DURATION)

  self:_updateStatus(Status.PREROUND_WAIT)
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

    if (not predicate or predicate(entity)) and self.map.area:IsInside(Vec2(x, y)) then
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
  self:_updateStatus(Status.ROUND_IN_PROGRESS)
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

  self:_clearTimers()

  self:_sendToPlayers('Match:Ended')

  local players = self.players
  self.players = { }

  for k,_ in pairs(players) do
    local player = PlayerManager:GetPlayerById(k)

    if player ~= nil then

      local soldier = player.soldier
      if soldier ~= nil and soldier.isAlive then
          print('Killing soldier')
          soldier:Kill()
      end

    end

  end

  self:_updateStatus(Status.MATCH_ENDED)

  self._playerLeftEvent:Unsubscribe()
  self._playerKilledEvent:Unsubscribe()
  self._soldierDamageHook:Uninstall()

end

function Match:_clearTimers()

  ClearTimeout(self._pregameWaitTimeout)
  ClearTimeout(self._preroundWaitTimeout)
  ClearTimeout(self._postmatchTimeout)
  ClearTimeout(self._roundEndedMovementTimeout)
  ClearTimeout(self._roundEndedWaitTimeout)
  ClearTimeout(self._matchEndedMovementTimeout)

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

  for k,v in pairs(self.scores) do

    if v > Match.ROUNDS / 2 then

        if not self:_sendToPlayers('Match:Completed', k) then
          self:stopMatch()
          return
        end

        self._matchEndedMovementTimeout = SetTimeout(function()
          self:toggleInput(false)
        end, Match.ROUND_ENDED_MOVEMENT_DURATION)

        self._postMatchTimeout = SetTimeout(function()
          print('Postmatch wait over, stopping match')

          self:stopMatch()
        end, Match.POST_MATCH_DURATION)

        self:_updateStatus(Status.POSTMATCH_WAIT)

        return
    end

  end

  self._roundEndedMovementTimeout = SetTimeout(function()
    self:toggleInput(false)
  end, Match.ROUND_ENDED_MOVEMENT_DURATION)

  if not self:_sendToPlayers('Round:Completed', GetOtherTeam(p.team)) then
    self:stopMatch()
    return
  end

  self.round = self.round + 1
  self:_updateStatus(Status.POSTROUND_WAIT)

  self._roundEndedWaitTimeout = SetTimeout(function()
    print('Postround wait over, starting round')
    self:_prepareRound()
  end, Match.POSTROUND_WAIT_DURATION)

end

function Match:_onDamageDealt(hook, soldier, info, giverInfo)

  if self.status ~= Status.ROUND_IN_PROGRESS then
    return
  end

  local receiverId = soldier.player.id

  if not self.players[receiverId] then
    return
  end

  local giverId = giverInfo.giver ~= nil and giverInfo.giver.id or nil
  local amount = math.min(soldier.health, info.damage)
  local lethal = info.damage >= soldier.health

  self:_sendToPlayers('Damage:Dealt', giverId, receiverId, amount, lethal)

end

function Match:_sendToPlayers(eventName, ...)

  local players = {}

  for k,_ in pairs(self.players) do

    local player = PlayerManager:GetPlayerById(k)

    if player == nil then
      return false
    end

    table.insert(players, player);

  end

  for _,v in pairs(players) do
    NetEvents:SendTo(eventName, v, ...)
  end

  return true

end

return Match