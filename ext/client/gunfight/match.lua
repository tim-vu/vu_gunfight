class('Match')

function Match:__init()

  self.team = nil

  Hooks:Install('UI:PushScreen', 1, self, self._onUIPushScreen)
  Events:Subscribe('Client:UpdateInput', self, self._onUpdateInput)

  NetEvents:Subscribe('Match:Joined', self, self._onMatchJoined)
  NetEvents:Subscribe('Match:Starting', self, self._onMatchStarting)
  NetEvents:Subscribe('Match:Completed', self, self._onMatchCompleted)
  NetEvents:Subscribe('Match:Ended', self, self._onMatchEnded)
  NetEvents:Subscribe('Round:Starting', self, self._onRoundStarting)
  NetEvents:Subscribe('Round:Started', self, self._onRoundStarted)
  NetEvents:Subscribe('Damage:Dealt', self, self._onDamageDealt)
  NetEvents:Subscribe('Round:Completed', self, self._onRoundCompleted)
end

function Match:_onUIPushScreen(hook, screen, priority, parentGraph)

  local screen = UIGraphAsset(screen)

  if screen.name == 'UI/Flow/Screen/IngameMenuMP' then
    WebUI:Hide()
    return
  end

  if screen.name == 'UI/Flow/Screen/HudScreen' then
    WebUI:Show()
    return
  end
end

function Match:_onMatchJoined(team)
  print('Joined match, team: ' .. tostring(team))
  self.team = team
end

function Match:_onMatchStarting(map, players)
  local call = string.format('matchStarting(%d, "%s", %s)', self.team, map, json.encode(players))
  print(call)
  WebUI:ExecuteJS(call)
  WebUI:DisableMouse()
end

function Match:_onMatchCompleted(winningTeam)

  local call = string.format('matchCompleted(%s)', tostring(winningTeam == self.team))

  print(call)

  WebUI:ExecuteJS(call)
end

function Match:_onMatchEnded()

  local call = 'matchStopped()'

  self.team = nil

  print(call)

  WebUI:ExecuteJS(call)
  WebUI:EnableMouse()
end

function Match:_onRoundStarting(loadout)
  local call = 'roundStarting(' .. json.encode(loadout) .. ')'

  print(call)

  WebUI:ExecuteJS(call)
end

function Match:_onRoundStarted(data)
  local call = 'roundStarted()'
  WebUI:ExecuteJS(call)

end

function Match:_onDamageDealt(giverId, receiverId, amount, lethal)
  local call = string.format('damageDealt(%s, %d, %f, %s)', json.encode(giverId), receiverId, amount, tostring(lethal));
  WebUI:ExecuteJS(call)
end

function Match:_onRoundCompleted(winningTeam)
  print('Round completed')
  local win = self.team == winningTeam and true or false

  local call = 'roundCompleted(' .. tostring(win) .. ')'

  print(call)

  WebUI:ExecuteJS(call)

end

function Match:_onUpdateInput(deltaTime)

  if InputManager:WentDown(InputConceptIdentifiers.ConceptScoreboard) then
    print('Showding scoreboard')
    WebUI:ExecuteJS('showScoreboard()')
    return
  end

  if InputManager:WentUp(InputConceptIdentifiers.ConceptScoreboard) then
    print('Hiding scoreboard')
    WebUI:ExecuteJS('hideScoreboard()')
    return
  end

end

if MatchInstance == nil then
  MatchInstance = Match()
end

return MatchInstance

