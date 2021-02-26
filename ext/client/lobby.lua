require('__shared/timer')

local Team = require('__shared/team')

local CAMERA_TRANSFORM = LinearTransform(
  Vec3(0, 0, 0),
  Vec3(0, 1, 0),
  Vec3(0, 0, 1),
  Vec3(0, 500, 0)
)

local Lobby = class('Lobby')

Lobby.static.LEAVE_TOAST_DELAY = 5000
Lobby.static.LEAVE_HOLD_DURATION = 3000

function Lobby:__init()

  self.init = false
  self.lastToastTimestamp = 0
  self.leaveTimeout = nil
  self.open = true
  self.camera = nil

  Events:Subscribe('WebUI:JoinMatch', self, self._joinMatch)
  Events:Subscribe('WebUI:JoinAnyMatch', self, self._joinAnyMatch)
  Events:Subscribe('WebUI:LeaveMatch', self, self._leaveMatch)

  Events:Subscribe('Client:UpdateInput', self, self._onUpdateInput)

  NetEvents:Subscribe('Lobby:Init', self, self._initLobby)
  NetEvents:Subscribe('Lobby:PlayerJoined', self, self._onPlayerJoined)
  NetEvents:Subscribe('Lobby:JoinFailed', self, self._joinMatchFailed)

  NetEvents:Subscribe('Lobby:PlayerLeft', self, self._onPlayerLeft)
  NetEvents:Subscribe('Lobby:LeaveFailed', self, self._leaveMatchFailed)
  NetEvents:Subscribe('Lobby:MatchStarting', self, self._onMatchStarting)
  NetEvents:Subscribe('Lobby:MatchEnded', self, self._onMatchEnded)
  NetEvents:Subscribe('Lobby:RoundCompleted', self, self._onRoundCompleted)
  NetEvents:Subscribe('Lobby:StatusChanged', self, self._onStatusChanged)

  Events:Subscribe('Player:Connected', self, self._onPlayerConnected)
  Events:Subscribe('Lobby:Show', self, self._showLobby)
  Events:Subscribe('Lobby:Hide', self, self._hideLobby)
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

  local cameraData = CameraEntityData()
  cameraData.fov = 90
  cameraData.transform = CAMERA_TRANSFORM
  cameraData.priority = 2

  local entity = EntityManager:CreateEntity(cameraData, CAMERA_TRANSFORM)

  if entity == nil then
    print('Unable to create camera')
    return
  end

  entity:Init(Realm.Realm_Client, true)

  self.camera = entity
  entity:FireEvent('TakeControl')

  print('Lobby camera created')

  NetEvents:Send('Lobby:Ready')
  self.init = true

end

function Lobby:_initLobby(matches)

  print('Initializing lobby')

  local matchesArray = {}

  for _, v in pairs(matches) do
    table.insert(matchesArray, v)
  end

  if #matchesArray == 0 then
    matchesArray = nil
  end

  local player = PlayerManager:GetLocalPlayer()

  WebUI:Init()

  local call = string.format('initializeLobby("%s", %d, %s)', player.name, player.id, json.encode(matchesArray))

  print(call)

  WebUI:ExecuteJS(call)

  self:_showLobby()
end

function Lobby:_showLobby()

  self.open = true

  WebUI:ExecuteJS('showLobby()')
  WebUI:BringToFront()
  WebUI:EnableMouse()

  if self.camera then
    print('Taking control')
    self.camera:FireEvent('TakeControl')
  end

end

function Lobby:_hideLobby()

  self.open = false

  print('Releasing control')
  self.camera:FireEvent('ReleaseControl')
end

function Lobby:_onUpdateInput(deltaTime)

  if not self.open then
    return
  end

  if InputManager:WentKeyUp(InputDeviceKeys.IDK_Escape) then

    local now = SharedUtils:GetTimeMS()

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
    ClearTimeout(self.leaveTimeout)
    self.leaveTimeout = nil
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

function Lobby:_onMatchStarting(mapId)
  local call = string.format('lobbyMatchStarted("%s")', mapId)
  print(call)
  WebUI:ExecuteJS(call)
end

function Lobby:_onStatusChanged(mapId, status)
  local call = string.format('matchStatusChanged("%s", %d)', mapId, status)
  print(call)
  WebUI:ExecuteJS(call)
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