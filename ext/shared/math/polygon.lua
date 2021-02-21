class('Polygon')

function Polygon:__init(...)
  self.points = {...}
end

function Polygon:IsInside(point)

  local minX = self.points[1].x
  local maxX = self.points[1].x
  local minY = self.points[1].y
  local maxY = self.points[1].y

  for _,p in pairs(self.points) do
    minX = math.min(minX, p.x)
    maxX = math.max(maxX, p.x)
    minY = math.min(minY, p.y)
    maxY = math.max(maxY, p.y)
  end

  if point.x < minX or point.x > maxX or point.y < minY or point.y > maxX then
    return false
  end

  -- https://wrf.ecse.rpi.edu/Research/Short_Notes/pnpoly.html
  local inside = false
  local i = 1
  local j = #self.points

  while i <= #self.points do

    if ((self.points[i].y > point.y) ~= (self.points[j].y > point.y)) and 
      point.x < (self.points[j].x - self.points[i].x) * (point.y - self.points[i].y) / 
      (self.points[j].y - self.points[i].y) + self.points[i].x then
      inside = not inside
    end

    j = i
    i = i + 1

  end

  return inside

end