require('setup/map-configurator')

class('Setup')

function Setup:__init(config)

  self.mapConfigurator = MapConfigurator(config.maps)

  Events:Subscribe('Client:UpdateInput', self, self._onUpdateInput)
  Events:Subscribe('FPSCamera:Update', self, self._onCameraUpdate)
  Events:Subscribe('WebUI:CloseConfig', self, self._onCloseConfig)

  self:_registerCommands()
end

function Setup:_onUpdateInput(deltaTime)

  if not InputManager:WentKeyDown(InputDeviceKeys.IDK_E) then
    return
  end

  local player = PlayerManager:GetLocalPlayer()

  if player == nil then
    return
  end

  local transform = ClientUtils:GetCameraTransform()
  local direction = Vec3(-transform.forward.x, -transform.forward.y, -transform.forward.z)

  local castStart = transform.trans
  local castEnd = Vec3(
    transform.trans.x + (direction.x * 100),
    transform.trans.y + (direction.y * 100),
    transform.trans.z + (direction.z * 100)
  )

  local hit = RaycastManager:Raycast(castStart, castEnd,
    RayCastFlags.DontCheckWater |
    RayCastFlags.DontCheckCharacter |
    RayCastFlags.DontCheckRagdoll |
    RayCastFlags.CheckDetailMesh
  )

  if not hit then
    return
  end

  NetEvents:Send('Setup:Teleport', hit.position)

end

local SPHERE_RADIUS = 0.1
local SPAWNPOINT_A_COLOR = Vec4(255, 0, 0, 1)
local SPAWNPOINT_B_COLOR = Vec4(0, 0, 255, 1)
local AREA_POINT_COLOR = Vec4(0, 255, 0, 1)
local AREA_LINE_COLOR = Vec4(0, 255, 0, 1)
local TEXT_COLOR = Vec4(0, 255, 0, 1)
local TEXT_X = 10
local TEXT_Y = 10
local TEXT_Y_STEP = 15

function Setup:_onCameraUpdate(deltaTime)

  local mapNames = {}

  for _, v in pairs(self.mapConfigurator.maps) do
    table.insert(mapNames, v.mapName)
  end

  local textY = TEXT_Y

  mapNames = table.concat(mapNames, ', ')
  DebugRenderer:DrawText2D(TEXT_X, textY, string.format('Maps: %s', mapNames), TEXT_COLOR, 1)

  local activeMapId = self.mapConfigurator.activeMap

  textY = textY + TEXT_Y_STEP
  DebugRenderer:DrawText2D(TEXT_X, textY, string.format('Active map: %s', activeMapId and activeMapId or 'None'), TEXT_COLOR, 1)

  local activeMap = self.mapConfigurator:getActiveMap()

  if not activeMap then
    return
  end

  textY = textY + TEXT_Y_STEP
  DebugRenderer:DrawText2D(TEXT_X, textY, string.format('Map name: %s', activeMap.mapName), TEXT_COLOR, 1)

  textY = textY + TEXT_Y_STEP
  DebugRenderer:DrawText2D(TEXT_X, textY, string.format('Teamsize: %d', activeMap.teamSize), TEXT_COLOR, 1)

  for _, p in pairs(activeMap.spawnpoints.A) do
    DebugRenderer:DrawSphere(p.trans, SPHERE_RADIUS, SPAWNPOINT_A_COLOR, false, false)
  end

  for _, p in pairs(activeMap.spawnpoints.B) do
    DebugRenderer:DrawSphere(p.trans, SPHERE_RADIUS, SPAWNPOINT_B_COLOR, false, false)
  end

  for _, p in pairs(activeMap.area) do
    DebugRenderer:DrawSphere(p, SPHERE_RADIUS, AREA_POINT_COLOR, false, false)
  end

  if #activeMap.area > 1 then

    for i = 1, #activeMap.area - 1 do
      DebugRenderer:DrawLine(activeMap.area[i], activeMap.area[i + 1], AREA_LINE_COLOR, AREA_LINE_COLOR)

    end

  end

  if #activeMap.area > 2 then
    DebugRenderer:DrawLine(activeMap.area[#activeMap.area], activeMap.area[1], AREA_LINE_COLOR, AREA_LINE_COLOR)
  end

end

function Setup:_onCloseConfig()

  WebUI:Hide()
  WebUI:DisableMouse()

end

local PLAYER_NOT_ALIVE_MESSAGE = 'The local player is not alive'

function Setup:_registerCommands()

  Console:Register('spawn', 'Spawns the player with the given loadout', function(args)

    if #args ~= 2 then
      return 'Invalid amount of arguments specified'
    end

    if tonumber(args[2]) == nil then
      return string.format('Invalid loadout index specified: %s', args[2])
    end

    local player = PlayerManager:GetLocalPlayer()

    if player.soldier == nil or not player.soldier.isAlive then
      return 'You must be alive to use this command'
    end

    NetEvents:Send('Command:Spawn', args[1], tonumber(args[2]))

  end)

  Console:Register('create_map', 'Creates a new map. Usage add_map mapId mapName', function(args)

    if #args < 2 then
      return 'The mapId and mapName are required'
    end

    args[2] = args[2]:gsub('"', '')

    local success, error = self.mapConfigurator:createMap(args[1], args[2])

    if not success then
      return error
    end

    return string.format('Succesfully added map %s', args[1])

  end)

  Console:Register('remove_map', 'Removes an existing map. Usage remove_map mapId', function(args)

    if #args < 1 then
      return 'The mapId is required'
    end

    local success, error = self.mapConfigurator:removeMap(args[1])

    if not success then
      return error
    end

    return string.format('Successfully removed %s', args[1])

  end)

  Console:Register('activate_map', 'Activates the given map. Usage: activate_map mapId', function(args)

    if #args < 1 then
      return 'The mapId is required'
    end

    local success, error = self.mapConfigurator:activateMap(args[1])

    if not success then
      return error
    end

    return string.format('Successfully activated map %s', args[1])
  end)

  Console:Register('set_teamsize', 'Sets the teamsize. Usage: set_teamsize x', function(args)

    if #args < 1 then
      return 'The teamsize is required'
    end

    local teamSize = tonumber(args[1])

    if not teamSize then
      return 'The given teamSize is not a valid integer'
    end

    if teamSize % 1 ~= 0 then
      return 'The teamSize must be a whole number'
    end

    local success, error = self.mapConfigurator:setTeamSize(teamSize)

    if not success then
      return error
    end

    return string.format('Successfully set the teamsize to %d', teamSize)
  end)

  Console:Register('clear_spawnpoints', 'Clears the spawnpoints of the map for a given side. Usage: clear_spawpoints A/B', function(args)

    if #args < 1 then
      return 'The side is required'
    end

    local success, error = self.mapConfigurator:clearSpawnPoints(args[1])

    if not success then
      return error
    end

    return string.format('Successfully cleared spawnpoints for side %s', args[1])

  end)

  Console:Register('add_spawnpoint', 'Adds a spawnpoint with the local player\' transform to the given side. Usage: add_spawnpoint A/B', function(args)

    if #args < 1 then
      return 'The side is required'
    end

    local player = PlayerManager:GetLocalPlayer()

    if player.soldier == nil or not player.soldier.isAlive then
      return PLAYER_NOT_ALIVE_MESSAGE
    end

    local success, error = self.mapConfigurator:addSpawnpoint(args[1], player.soldier.transform)

    if not success then
      return error
    end

    return string.format('Successfully added a spawnpoint for side %s', args[1])
  end)

  Console:Register('remove_spawnpoint', 'Removes the closest spawnpoint to the local player. Usage: remove_spawnpoint', function(args)

    local player = PlayerManager:GetLocalPlayer()

    if player.soldier == nil or not player.soldier.isAlive then
      return PLAYER_NOT_ALIVE_MESSAGE
    end

    local success, error = self.mapConfigurator:removeClosestSpawnpoint(player.soldier.transform.trans)

    if not success then
      return error
    end

    return 'Succesfully removed the closest spawnpoint'
  end)

  Console:Register('clear_area_points', 'Clears the area points, Usage: clear_area_points', function(args)
    self.mapConfigurator:clearAreaPoints()
    return 'Successfully cleared the area points'
  end)

  Console:Register('remove_area_point', 'Removes the last area point', function(args)

    local success, error = self.mapConfigurator:removeLastAreaPoint()

    if not success then
      return error
    end

    return 'Successfully removed the last area point'

  end)

  Console:Register('add_area_point', 'Adds a point with the local player\'s position to the area. Usage: add_area_point', function(args)

    local player = PlayerManager:GetLocalPlayer()

    if player.soldier == nil or not player.soldier.isAlive then
      return PLAYER_NOT_ALIVE_MESSAGE
    end

    local success, error = self.mapConfigurator:addAreaPoint(player.soldier.transform.trans)

    if not success then
      return error
    end

    return string.format('Successfully added a point to the area')
  end)

  Console:Register('generate_config', 'Generates the map config', function(args)

    local success, result = self.mapConfigurator:generateMapConfig()

    if not success then
      return result
    end

    local config = {
      content = result
    }

    WebUI:Show()
    WebUI:EnableMouse()

    local call = string.format('showConfig(%s)', json.encode(config))

    print(call)

    WebUI:ExecuteJS(call)

  end)

end
