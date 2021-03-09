require('__shared/math/polygon')
require('__shared/common')

class('MapConfigurator')

function MapConfigurator:__init(maps)

  self.maps = maps

  if not self.maps then
    self.maps = {}
  end

  self.activeMap = nil

end

local MINIMUM_NAME_LENGTH = 3
local ALLOWED_MAP_ID_CHARACTERS = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'
local ALLOWED_NAME_CHARACTERS = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 '
local NO_MAP_ACTIVE_MESSAGE = 'No map is currently active'

function MapConfigurator:createMap(mapId, mapName)

  if not MapConfigurator:_isValidName(mapId, ALLOWED_MAP_ID_CHARACTERS) then
    return false, 'The given map id is not valid'
  end

  if self.maps[mapId] then
    return false, 'The given map id already exists'
  end

  if not MapConfigurator:_isValidName(mapName, ALLOWED_NAME_CHARACTERS) then
    print(mapName)
    return false, 'The given map name is not valid'
  end

  self.maps[mapId] = {
    mapName = mapName,
    teamSize = 2,
    spawnpoints = {
      A = {},
      B = {}
    },
    area = {}
  }

  return true

end

function MapConfigurator:removeMap(mapId)

  if not self.maps then
    return false, 'The given map does not exist'
  end

  self.maps[mapId] = nil

  if self.activeMap == mapId then
    self.activeMap = nil
  end

  return true

end

function MapConfigurator.static:_isValidName(name, allowedCharacters)

  if type(name) ~= 'string' or string.len(name) < MINIMUM_NAME_LENGTH then
    return false
  end

  for i = 1, #name do
    local c = name:sub(i, i)

    if not string.find(allowedCharacters, c) then
      return false
    end

  end

  return true
end

function MapConfigurator:activateMap(mapId)

  if not self.maps[mapId] then
    return false, 'The given map does not exist'
  end

  self.activeMap = mapId
  return true
end

function MapConfigurator:setTeamSize(size)

  local activeMap = self:getActiveMap()

  if not activeMap then
    return false, NO_MAP_ACTIVE_MESSAGE
  end

  if type(size) ~= "number" or size < 1 or size > 3 then
    return false, 'The teamsize must be between 1 and 3'
  end

  activeMap.teamSize = size
  return true
end

function MapConfigurator:clearSpawnPoints(side)

  local activeMap = self:getActiveMap()

  if not activeMap then
    return false, NO_MAP_ACTIVE_MESSAGE
  end

  if type(side) ~= "string" or (side ~= 'A' and side ~= 'B') then
    return false, 'The side must be either A or B'
  end

  activeMap.spawnpoints[side] = {}
  return true
end

function MapConfigurator:addSpawnpoint(side, transform)

  local activeMap = self:getActiveMap()

  if not activeMap then
    return false, NO_MAP_ACTIVE_MESSAGE
  end

  if type(side) ~= "string" or (side ~= 'A' and side ~= 'B') then
    return false, 'The side must be either A or B'
  end

  if transform == nil then
    return false, 'The given transform is not valid'
  end

  table.insert(activeMap.spawnpoints[side], transform)

  return true
end

local MAX_DISTANCE = 999999999999999999999999

function MapConfigurator:removeClosestSpawnpoint(position)

  local activeMap = self:getActiveMap()

  if not activeMap then
    return false, NO_MAP_ACTIVE_MESSAGE
  end

  local spawnpoints = activeMap.spawnpoints.A
  local distance = MAX_DISTANCE
  local index = -1

  for k, v in pairs(activeMap.spawnpoints.A) do

    local dist = v.trans:Distance(position)

    if dist < distance then
      index = k
      distance = dist
    end

  end

  for k, v in pairs(activeMap.spawnpoints.B) do

    local dist = v.trans:Distance(position)

    if dist < distance then
      spawnpoints = activeMap.spawnpoints.B
      index = k
      distance = dist
    end

  end

  if index == -1 then
    return false, 'There are not spawnpoints to remove'
  end

  table.remove(spawnpoints, index)
  return true

end

function MapConfigurator:clearAreaPoints()

  local activeMap = self:getActiveMap()

  if not activeMap then
    return false, NO_MAP_ACTIVE_MESSAGE
  end

  activeMap.area = {}

end

function MapConfigurator:addAreaPoint(position)

  local activeMap = self:getActiveMap()

  if not activeMap then
    return false, NO_MAP_ACTIVE_MESSAGE
  end

  if position == nil then
    return false, 'The given position is not valid'
  end

  table.insert(activeMap.area, position)
  return true
end

function MapConfigurator:removeLastAreaPoint()

  local activeMap = self:getActiveMap()

  if not activeMap then
    return false, NO_MAP_ACTIVE_MESSAGE
  end

  table.remove(activeMap.area, #activeMap.area)

end

function MapConfigurator:getActiveMap()
  return self.maps[self.activeMap]
end

local MAP_CONFIGURATION_TEMPLATE = [[
  ['%s'] = {
    mapName = '%s',
    teamSize = %d,
    spawnpoints = {
      A = {
        %s
      },
      B = {
        %s
      }
    },
    area = {
      %s
    },
    loadouts = {}
  }]]

function MapConfigurator:_serializeSpawnpoints(spawnpoints)

  local spawnpointStrings = {}

  for i = 1, #spawnpoints do
    local transform = spawnpoints[i]
    spawnpointStrings[i] = string.format('LinearTransform(Vec3%s, Vec3%s, Vec3%s, Vec3%s)', transform.left, transform.up, transform.forward, transform.trans)
  end

  return table.concat(spawnpointStrings, ',\n        ')
end

function MapConfigurator:_serializeAreaPoints(points)

  local pointStrings = {}

  for i = 1, #points do
    local point = points[i]
    pointStrings[i] = string.format('Vec3%s', point)
  end

  return table.concat(pointStrings, ',\n      ')
end

function MapConfigurator:generateMapConfig()

  for k, map in pairs(self.maps) do

    if #map.spawnpoints.A < map.teamSize or #map.spawnpoints.B < map.teamSize then
      return false, string.format('%s does not have enough spawnpoints, there must be a least %d spawnpoints for each side', k, map.teamSize)
    end

    if #map.area < 3 then
      return false, string.format('%s does not have enough area points, at least 3 are required', k)
    end

    local area = {}

    for _, position in pairs(map.area) do
      table.insert(area, Vec2(position.x, position.z))
    end

    for _, side in pairs(map.spawnpoints) do
      for _, point in pairs(side) do

        local p = Vec2(point.trans.x, point.trans.z)

        if not Polygon:isInside(area, p) then
          return false, string.format('A spawnpoint of %s lies outside the area', k)
        end

      end
    end

  end

  local mapStrings = { }

  for k, v in pairs(self.maps) do

    table.insert(mapStrings, string.format(MAP_CONFIGURATION_TEMPLATE,
      k,
      v.mapName,
      v.teamSize,
      self:_serializeSpawnpoints(v.spawnpoints.A),
      self:_serializeSpawnpoints(v.spawnpoints.B),
      self:_serializeAreaPoints(v.area)
    ))

  end

  return true, 'return {\n' .. table.concat(mapStrings, ',\n') .. '\n}'

end