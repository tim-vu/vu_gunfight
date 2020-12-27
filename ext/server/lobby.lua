require('__shared/common')
local Match = require('gunfight/match')
local Team = require('__shared/team')

local Status = require('__shared/status')

local Lobby = class('Lobby')

function Lobby.static:compareMatch(a, b)

  local remainingSlotsA = a.map.teamSize * Match.TEAMS - GetCount(a.players)
  local remainingSlotsB = b.map.teamSize * Match.TEAMS - GetCount(b.players)

  return remainingSlotsA < remainingSlotsB

end

function Lobby.static:matchToMatchVm(match)
  local matchVm = {
    mapId = match.mapId,
    map = match.map.displayName,
    teamSize = match.map.teamSize,
    startTime = match.timestamp,
    status = match.status,
    players = {}
  }

  for _,v in pairs(match.players) do
    table.insert(matchVm.players, { id = v.id, team = v.team, name = v.name})
  end

  if #matchVm.players == 0 then
    matchVm.players = nil
  end

  return matchVm

end


function Lobby:__init(maps)

  self.matches = {}

  print('Maps loaded: ' .. GetCount(maps))

  for k,v in pairs(maps) do
    self.matches[k] = Match(k, v)
  end

  Events:Subscribe('Player:Created', self, self._onPlayerCreated)

  Events:Subscribe('Match:Ended', self, self._onMatchEnded)
  Events:Subscribe('Match:PlayerLeft', self, self._onPlayerLeftMatch)
  Events:Subscribe('Match:RoundCompleted', self, self._onRoundCompleted)

  NetEvents:Subscribe('Lobby:Ready', self, self._refresh)
  NetEvents:Subscribe('Lobby:Join', self, self._joinMatch)
  NetEvents:Subscribe('Lobby:JoinAny', self, self._joinAnyMatch)
  NetEvents:Subscribe('Lobby:Leave', self, self._leaveMatch)

end

function Lobby:_refresh(player)

  local matches = { }

  for _,v in pairs(self.matches) do
    table.insert(matches, Lobby:matchToMatchVm(v))
  end

  NetEvents:SendTo('Lobby:Init', player, matches)
end

function Lobby:_joinMatch(player, mapId, team)

  local match = self.matches[mapId]

  if match == nil then
    NetEvents:SendTo('Lobby:JoinFailed', player, 'The given match does not exist')
    return
  end

  if match.status ~= Status.NOT_STARTED  then
    NetEvents:SendTo('Lobby:JoinFailed', player, 'The given match is already in progress')
  end

  local success, error = match:Join(player, team)

  if not success then
    NetEvents:SendTo('Lobby:JoinFailed', player, error)
    return
  end

  NetEvents:Broadcast('Lobby:PlayerJoined', mapId, match.players[player.id])

end

function Lobby:_joinAnyMatch(player)

  local sortedMatches = { }

  for k,v in pairs(self.matches) do

    if not v:IsFull() then
      table.insert(sortedMatches, k)
    end

  end

  if #sortedMatches == 0 then
    NetEvents:SendTo('Lobby:JoinFailed', player, 'No matches available')
  end

  local compareMapId = function(a, b)
    return Lobby:compareMatch(self.matches[a], self.matches[b])
  end

  table.sort(sortedMatches, compareMapId)

  local match = self.matches[sortedMatches[1]]
  local team = match:IsTeamFull(Team.US) and Team.RU or Team.US

  self:_joinMatch(player, match.mapId, team)

end

function Lobby:_leaveMatch(player)

  for _,v in pairs(self.matches) do

    if v.players[player.id] ~= nil then
      v:Leave(player)
      NetEvents:SendTo('Lobby:Left', player)
      return
    end

  end

  NetEvents:SendTo('Lobby:LeaveFailed', player, 'The player was not in a match')

end


function Lobby:_onPlayerCreated(player)

  local matches = { }

  for k,v in pairs(self.matches) do

    print('Map id: ' .. k)

    table.insert(matches, Lobby:matchToMatchVm(v))
  end

  print('Sending maps')
  NetEvents:SendTo('Lobby:Init', player, matches)

end

function Lobby:_onPlayerLeftMatch(mapId, playerId)
  NetEvents:Broadcast('Lobby:PlayerLeft', mapId, playerId)
end

function Lobby:_onRoundCompleted(mapId)
  local match = self.matches[mapId]
  NetEvents:Broadcast('Lobby:RoundCompleted', mapId, match.scores)
end

function Lobby:_onMatchEnded(mapId)

  local oldMatch = self.matches[mapId]

  self.matches[mapId] = Match(oldMatch.mapId, oldMatch.map)

  NetEvents:Broadcast('Lobby:MatchEnded', mapId)

end

return Lobby