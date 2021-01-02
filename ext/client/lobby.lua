require('__shared/timer')

local Team = require('__shared/team')

local Lobby = class('Lobby')

Lobby.static.LEAVE_TOAST_DELAY = 5
Lobby.static.LEAVE_HOLD_DURATION = 3

function Lobby:__init()

  self.init = false
  self.lastToastTimestamp = 0
  self.leaveTimeout = nil
  self.open = true

  Events:Subscribe('WebUI:JoinMatch', self, self._joinMatch)
  Events:Subscribe('WebUI:JoinAnyMatch', self, self._joinAnyMatch)
  Events:Subscribe('WebUI:LeaveMatch', self, self._leaveMatch)
  Hooks:Install('UI:PushScreen', 1, self, self._onUIPushScreen)
  Events:Subscribe('Client:UpdateInput', self, self._onUpdateInput)

  NetEvents:Subscribe('Lobby:Init', self, self._initLobby)
  NetEvents:Subscribe('Lobby:PlayerJoined', self, self._onPlayerJoined)
  NetEvents:Subscribe('Lobby:JoinFailed', self, self._joinMatchFailed)
  NetEvents:Subscribe('Lobby:PlayerLeft', self, self._onPlayerLeft)
  NetEvents:Subscribe('Lobby:LeaveFailed', self, self._leaveMatchFailed)
  NetEvents:Subscribe('Lobby:MatchEnded', self, self._onMatchEnded)
  NetEvents:Subscribe('Lobby:RoundCompleted', self, self._onRoundCompleted)

  Events:Subscribe('Player:Connected', self, self._onPlayerConnected)
  Events:Subscribe('Lobby:Show', self, self._showLobby)

end

function Lobby:_onPlayerConnected(player)

  if self.init then
    return
  end

  local localPlayer = PlayerManager:GetLocalPlayer()

  if localPlayer == nil then
    return
  end

  if localPlayer.id ~= player.id then
    return
  end

  NetEvents:Send('Lobby:Ready')
  self.init = true

end

function Lobby:_initLobby(matches)

  print('Initializing lobby')

  local matchesArray = {}

  for _,v in pairs(matches) do
    table.insert(matchesArray, v)
  end

  if #matchesArray == 0 then
    matchesArray = nil
  end

  local player = PlayerManager:GetLocalPlayer()

  if player == nil then
    print('player nil')
  end

  WebUI:Init()

  local call = string.format('initializeLobby("%s", %d, %s)', player.name, player.id, json.encode(matchesArray))

  print(call)

  WebUI:ExecuteJS(call)

  self:_showLobby()
end


function Lobby:_showLobby()
  WebUI:ExecuteJS('showLobby()')
  WebUI:EnableMouse()
end

function Lobby:_onUIPushScreen(hook, screen, priority, parentGraph)

  local screen = UIGraphAsset(screen)

  if screen.name == 'UI/Flow/Screen/SpawnScreenPC' then
    self.open = true
    return
  end

  if screen.name == 'UI/Flow/Screen/HudTDMScreen' then
    self.open = false
    return
  end
end

function Lobby:_onUpdateInput(deltaTime)

  if not self.open then
    return
  end
  if InputManager:WentKeyUp(InputDeviceKeys.IDK_Escape) then

    local now = os.clock()

    if self.lastToastTimestamp + Lobby.LEAVE_TOAST_DELAY < now then
      print('Showing toast')
      WebUI:ExecuteJS('showLeaveGameToast()')
      self.lastToastTimestamp = now
      return
    end

    return
  end

  if InputManager:WentKeyDown(InputDeviceKeys.IDK_Escape) and self.leaveTimeout == nil then
    print('Starting leave')
    self.leaveTimeout = SetTimeout(function()
      NetEvents:Send('Lobby:LeaveGame')
    end, Lobby.LEAVE_HOLD_DURATION)
    return
  end

  if not InputManager:IsKeyDown(InputDeviceKeys.IDK_Escape) and self.leaveTimeout ~= nil then
    print('Stopping leave')
    ClearTimeout(self.leaveTimeout)
  end


end

function Lobby:_refresh()
  NetEvents:Send('Lobby:Refresh')
end

function Lobby:_joinAnyMatch()
  print('Trying to join any')

  NetEvents:Send('Lobby:JoinAny')
end

function Lobby:_joinMatch(dataString)

  local data = json.decode(dataString)

  NetEvents:Send('Lobby:Join', data.mapId, data.team)
end

function Lobby:_onPlayerJoined(mapId, player)

  local call = string.format('joinedMatch("%s", %s)', mapId, json.encode(player))

  print(call)

  WebUI:ExecuteJS(call)

end

function Lobby:_joinMatchFailed(reason)
  print('Joining match failed: ' .. reason)
end

function Lobby:_leaveMatch()
  print('Trying to leave match')
  NetEvents:Send('Lobby:Leave')
end

function Lobby:_onPlayerLeft(mapId, playerId)
  local call = string.format('leftMatch("%s", %d)', mapId, playerId)

  print(call)

  WebUI:ExecuteJS(call)
end

function Lobby:_leaveMatchFailed(reason)
  print('Leaving match failed: ' .. reason)
end

function Lobby:_onRoundCompleted(mapId, scores)

  local call = string.format('updateScore("%s", %d, %d)', mapId, scores[Team.US], scores[Team.RU])

  print(call)

  WebUI:ExecuteJS(call)
end

function Lobby:_onMatchEnded(mapId)

  local call = string.format('resetMatch("%s")', mapId)

  print(call)

  WebUI:ExecuteJS(call)

end

return Lobby