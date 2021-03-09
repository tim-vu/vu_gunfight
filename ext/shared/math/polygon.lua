class('Polygon')

function Polygon.static:isInside(p, point)

  local minX = p[1].x
  local maxX = p[1].x
  local minY = p[1].y
  local maxY = p[1].y

  for _,p in pairs(p) do
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
  local j = #p

  while i <= #p do

    if ((p[i].y > point.y) ~= (p[j].y > point.y)) and 
      point.x < (p[j].x - p[i].x) * (point.y - p[i].y) / 
      (p[j].y - p[i].y) + p[i].x then
      inside = not inside
    end

    j = i
    i = i + 1

  end

  return inside

end