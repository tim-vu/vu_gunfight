require('__shared/common')
local Match = require('gunfight/match')

local Status = require('__shared/status')

local Lobby = class('Lobby')

function Lobby.static:compareMatch(a, b)

  local remainingSlotsA = a.map.teamSize * Match.TEAMS - #pairs(a.players)
  local remainingSlotsB = b.map.teamSize * Match.TEAMS - #pairs(b.players)

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
    table.insert(matchVm.players, { id = v.id, team = v.team})
  end

  return matchVm

end


function Lobby:__init(maps)

  self.matches = {}

  print('Maps loaded: ' .. GetCount(maps))

  for k,v in pairs(maps) do
    self.matches[k] = Match(k, v)
  end

  Events:Subscribe('Player:Authenticated', self, self._onPlayerAuthenticated)

  Events:Subscribe('Match:Ended', self, self._onMatchEnded)

  NetEvents:Subscribe('Lobby:Refresh', self, self._refresh)
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

  NetEvents:SendTo('Lobby:Joined', player, mapId, team)

end

function Lobby:_joinAnyMatch(player)

  local sortedMatches = { }

  for k,v in pairs(self.matches) do
    
    if not v:IsFull() then
      table.insert(sortedMatches, k)
    end

  end

  if #sortedMatches == 0 then
    NetEvents:SendTo('Lobby:JoinFailed', 'No matches available')
  end

  local compareMapId = function(a, b)
    return Lobby.compareMatch(self.matches[a], self.matches[b])
  end

  table.sort(sortedMatches, compareMapId)

  local mapId = sortedMatches[1]

  self:_joinMatch(mapId, player)

end

function Lobby:_leaveMatch(player)

  for _,v in pairs(self.matches) do

    if v.players[player.id] ~= nil then
      v:Leave(player)
      NetEvents:SendTo('Lobby:Left')
      return
    end

  end

  NetEvents:SendTo('Match:LeaveFailed', 'The player was not in a match')

end


function Lobby:_onPlayerAuthenticated(player)

  local matches = { }

  for k,v in pairs(self.matches) do

    print('Map id: ' .. k)

    table.insert(matches, Lobby:matchToMatchVm(v))
  end

  print('Sending maps')
  NetEvents:SendTo('Lobby:Init', player, matches)

end

function Lobby:_onMatchEnded(mapId)

  local oldMatch = self.matches[mapId]

  self.matches[mapId] = Match(oldMatch.mapId, oldMatch.map)

  NetEvents:Broadcast('Lobby:MatchUpdate', Lobby:matchToMatchVm(self.matches[mapId]))

end

return Lobby