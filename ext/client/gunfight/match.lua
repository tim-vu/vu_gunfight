require('__shared/team')

class('Match')

function Match:__init()

  self.team = nil

  NetEvents:Subscribe('Match:JoinFailed', self, self._onJoinFailed)
  NetEvents:Subscribe('Match:Joined', self, self._onMatchJoined)
  NetEvents:Subscribe('Match:Starting', self, self._onMatchStarting)
  NetEvents:Subscribe('Match:Completed', self, self._onMatchCompleted)
  NetEvents:Subscribe('Match:Ended', self, self._onMatchEnded)
  NetEvents:Subscribe('Round:Starting', self, self._onRoundStarting)
  NetEvents:Subscribe('Round:Started', self, self._onRoundStarted)
  NetEvents:Subscribe('Damage:Dealt', self, self._onDamageDealt)
  NetEvents:Subscribe('Round:Completed', self, self._onRoundCompleted)

end

function Match:_onJoinFailed(reason)

  print('Join failed: ' .. tostring(data))

end

function Match:_onMatchJoined(team)

  print('Joined match, team: ' .. tostring(team))

  self.team = team

end

function Match:_onMatchStarting(players)

  local call = string.format('matchStarting(%d, %s)', self.team, json.encode(players))

  print(call)

  WebUI:ExecuteJS(call)
end

function Match:_onMatchCompleted(winningTeam)

  print('Match completed ' .. tostring(winningTeam))

  --TODO

end

function Match:_onMatchEnded(data)

  print('Match ended')

  self.team = nil

  WebUI:ExecuteJS('matchStopped()')

end

function Match:_onRoundStarting(loadout)

  local call = 'roundStarting(' .. json.encode(loadout) .. ')'

  print(call)

  WebUI:ExecuteJS(call)

end

function Match:_onRoundStarted(data)

  local call = 'roundStarted()'

  print(call)

  WebUI:ExecuteJS(call)

end

function Match:_onDamageDealt(data)

  local call = string.format('damageDealt(%d, %d, %f)', data.giverId, data.receiverId, data.amount);

  print(call)

  WebUI:ExecuteJS(call)
end

function Match:_onRoundCompleted(winningTeam)
  print('Round completed')
  local win = self.team == winningTeam and true or false

  local call = 'roundCompleted(' .. tostring(win) .. ')'

  print(call)

  WebUI:ExecuteJS(call)

end

if MatchInstance == nil then
  MatchInstance = Match()
end

return MatchInstance

