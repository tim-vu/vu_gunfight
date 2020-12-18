local Lobby = class('Lobby')

function Lobby:__init()

  self.matches = {}

  Events:Subscribe('WebUI:JoinMatch', self, self._joinMatch)
  Events:Subscribe('WebUI:JoinAnyMatch', self, self._joinAnyMatch)
  Events:Subscribe('WebUI:LeaveMatch', self, self._leaveMatch)

  NetEvents:Subscribe('Lobby:Init', self, self._initLobby)
  NetEvents:Subscribe('Lobby:Joined', self, self._joined)
  NetEvents:Subscribe('Lobby:JoinFailed', self, self._joinMatchFailed)
  NetEvents:Subscribe('Lobby:Left', self, self._left)
  NetEvents:Subscribe('Match:LeaveFailed', self, self._leaveMatchFailed)
end

function Lobby:_initLobby(matches)

  print('Initializing lobby')
  self.matches = {}

  for _,v in pairs(matches) do
    self.matches[v.mapId] = v
  end

end

function Lobby:_refresh()
  NetEvents:Send('Lobby:Refresh')
end

function Lobby:_matchUpdate(match)
  self.matches[match.mapId] = match
end

function Lobby:_joinMatch(dataString)

  local data = json.decode(dataString)

  NetEvents:Send('Lobby:Join', data.mapId, data.team)
end

function Lobby:_joinAnyMatch()
  NetEvents:Send('Lobby:JoinAny')
end

function Lobby:_leaveMatch()
  NetEvents:Send('Lobby:Leave')
end

function Lobby:_joined(mapId, team)
  print('Joined match: ' .. mapId .. ', team: ' .. tostring(team))
end

function Lobby:_joinMatchFailed(reason)
  print('Joining match failed: ' .. reason)
end

function Lobby:_left()
  print('Left match')
end

function Lobby:_leaveMatchFailed(reason)
  print('Leaving match failed: ' .. reason)
end

return Lobby