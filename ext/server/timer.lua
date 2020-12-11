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

        print('Executing interval')

        event.callback()

        event.timestamp = now

      end

    else

      if event.timestamp < now then

        print('Executing timeout')
  
        event.callback()
  
        table.remove(events, i)
      end

    end


  end

  if #events == 0 then
    print('No timeouts remaining, unsubscribing')
    engineUpdateEvent:Unsubscribe()
    engineUpdateEvent = nil
  end

end

function SetTimeout(func, delay)

  print('Adding timeout')
  table.insert(events, {
    callback = func,
    timestamp = os.clock() + delay,
    interval = false,
  })

  if #events == 1 then
    print('Subscribing')
    engineUpdateEvent = Events:Subscribe('Engine:Update', onEngineUpdate)
  end

end
