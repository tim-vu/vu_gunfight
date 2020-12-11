class('Rectangle')

function Rectangle:__init(x1, y1, x2, y2)

  self.x1 = x1
  self.y1 = y1
  self.x2 = x2
  self.y2 = y2

end

function Rectangle:IsInside(x, y)
  return x > self.x1 and x < self.x2 and y > self.y1 and y < self.y2
end