GetCount = function(table)

  local n = 0
  for _, _ in pairs(table) do
      n = n + 1
  end

  return n

end

ArrayContains = function(array, value)

  for _, v in pairs(array) do

    if v == value then
      return true
    end

  end

  return false

end