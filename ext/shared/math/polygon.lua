class('Polygon')

function Polygon.static:isInside(polygon, point)

  local minX = polygon[1].x
  local maxX = polygon[1].x
  local minY = polygon[1].y
  local maxY = polygon[1].y

  for _,p in pairs(polygon) do
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
  local j = #polygon

  while i <= #polygon do

    if ((polygon[i].y > point.y) ~= (polygon[j].y > point.y)) and 
      point.x < (polygon[j].x - polygon[i].x) * (point.y - polygon[i].y) / 
      (polygon[j].y - polygon[i].y) + polygon[i].x then
      inside = not inside
    end

    j = i
    i = i + 1

  end

  return inside

end