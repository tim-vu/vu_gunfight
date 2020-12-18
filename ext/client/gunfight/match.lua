class('Match')

function Match:__init()

  self.team = nil

  Events:Subscribe('Extension:Loaded', self._onExtensionLoaded)
  Hooks:Install('UI:PushScreen', 1, self, self._onUIPushScreen)

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

function Match:_onExtensionLoaded(levelName, gameMode)

  WebUI:Init()
  WebUI:BringToFront()
end

function Match:_onMatchJoined(team)
  print('Joined match, team: ' .. tostring(team))
  self.team = team
end

function Match:_onMatchStarting(players)
  local call = string.format('matchStarting(%d, %s)', self.team, json.encode(players))
  WebUI:ExecuteJS(call)
end

function Match:_onMatchCompleted(winningTeam)
  WebUI:ExecuteJS('matchCompleted()')
end

function Match:_onMatchEnded(data)

  print('Match ended')

  self.team = nil

  WebUI:ExecuteJS('matchStopped()')

end

function Match:_onRoundStarting(loadout)
  local call = 'roundStarting(' .. json.encode(loadout) .. ')'
  WebUI:ExecuteJS(call)

end

function Match:_onRoundStarted(data)
  local call = 'roundStarted()'
  WebUI:ExecuteJS(call)

end

function Match:_onDamageDealt(data)
  local call = string.format('damageDealt(%s, %d, %f)', tostring(data.giverId), data.receiverId, data.amount);
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

