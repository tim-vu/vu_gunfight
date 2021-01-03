local Status = require('__shared/status')

class('Match')

function Match:__init()

  self.team = nil
  self.deathCamera = nil
  self.status = Status.NOT_STARTED

  Hooks:Install('UI:PushScreen', 1, self, self._onUIPushScreen)
  Events:Subscribe('Client:UpdateInput', self, self._handleKeyboard)
  Events:Subscribe('Client:UpdateInput', self, self._handleDeathCamera)

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

function Match:_onMatchStarting(map, teamSize, players)
  local call = string.format('matchStarting(%d, %d, "%s", %s)', self.team, teamSize, map, json.encode(players))
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

  self.status = Status.MATCH_ENDED

  print('Match ended')
  self:_clearCam()
  Events:Dispatch('Lobby:Show')
end

function Match:_onRoundStarting(loadout)

  self.status = Status.PREROUND_WAIT

  local call = 'roundStarting(' .. json.encode(loadout) .. ')'

  print(call)

  WebUI:ExecuteJS(call)
end

function Match:_onRoundStarted(data)

  self.status = Status.ROUND_IN_PROGRESS

  local call = 'roundStarted()'
  WebUI:ExecuteJS(call)

end

function Match:_onDamageDealt(giverId, receiverId, amount, lethal)
  local call = string.format('damageDealt(%s, %d, %f, %s)', json.encode(giverId), receiverId, amount, tostring(lethal));
  WebUI:ExecuteJS(call)
end

function Match:_onRoundCompleted(winningTeam)

  self.status = Status.POSTROUND_WAIT

  print('Round completed')
  local win = self.team == winningTeam and true or false

  local call = 'roundCompleted(' .. tostring(win) .. ')'

  print(call)

  WebUI:ExecuteJS(call)

end

function Match:_handleKeyboard(deltaTime)

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

function Match:_clearCam()

  if self.deathCamera == nil then
    return
  end

  self.deathCamera:FireEvent('ReleaseControl')
  self.deathCamera:Destroy()
  self.deathCamera = nil

  print('Camera cleared')

end

function Match:_handleDeathCamera(deltaTime)

  local player = PlayerManager:GetLocalPlayer()

  if player == nil then
    return
  end

  if player.soldier ~= nil or self.status == Status.MATCH_ENDED or self.status == Status.NOT_STARTED then
    self:_clearCam()
    return
  end

  if self.deathCamera ~= nil then
    return
  end

  print('Creating deathcam')

  local transform = ClientUtils:GetCameraTransform()

  local cameraData = CameraEntityData()
  cameraData.fov = 90
  cameraData.transform = transform
  cameraData.priority = 1

  local entity = EntityManager:CreateEntity(cameraData, transform)

  if entity == nil then
    print('Unable to create camera')
    return
  end

  entity:Init(Realm.Realm_Client, true)

  self.deathCamera = entity

  self.deathCamera:FireEvent('TakeControl')

end

if MatchInstance == nil then
  MatchInstance = Match()
end

return MatchInstance

