local events = {}
local engineUpdateEvent = nil

local function onEngineUpdate(deltaTime, simulationDeltaTime)

  if #events == 0 then
    return
  end

  local now = os.clock()
  for i = #events, 1, -1 do

    local event = events[i]

    if event.interval then

      if event.timestamp < now - event.delay then

        event.callback()

        event.timestamp = now

      end

    else

      if event.timestamp < now then

        event.callback()

        table.remove(events, i)
      end

    end


  end

  if #events == 0 then
    engineUpdateEvent:Unsubscribe()
    engineUpdateEvent = nil
  end

end

function SetTimeout(func, delay)

  local timeout = {
    callback = func,
    timestamp = os.clock() + delay,
    interval = false,
  }

  table.insert(events, timeout)

  if #events == 1 then
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

  if #events == 0 and engineUpdateEvent ~= nil then
    engineUpdateEvent:Unsubscribe()
    engineUpdateEvent = nil
  end

end
