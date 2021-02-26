local events = {}
local engineUpdateEvent = nil

local function onEngineUpdate(deltaTime, simulationDeltaTime)

  local now = SharedUtils:GetTimeMS()

  for i = #events, 1, -1 do

    local event = events[i]

    if event.timestamp < now then

      event.callback()

      table.remove(events, i)
    end

  end

end

function SetTimeout(func, delay)

  local timeout = {
    callback = func,
    timestamp = SharedUtils:GetTimeMS() + delay,
    interval = false,
  }

  table.insert(events, timeout)

  if not engineUpdateEvent then
    engineUpdateEvent = Events:Subscribe('Engine:Update', onEngineUpdate)
  end

  return timeout
end

function ClearTimeout(timeout)

  for k = #events, 1, -1 do

    if events[k] == timeout then
      table.remove(events, k)
    end

  end

end
