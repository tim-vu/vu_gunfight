local Team = require('__shared/team')

local registerSetupCommands = function()

Console:Register('spawn', 'Spawns the player', function(args) NetEvents:Send('Spawn') end)

Console:Register('transform', "Prints the player's current transform", function(args)
  local player = PlayerManager:GetLocalPlayer()

  if player.soldier == nil or not player.soldier.isAlive then
    return 'The player is currently not alive'
  end

  local transform = player.soldier.transform

  return string.format('LinearTransform(\n  Vec3%s,\n  Vec3%s,\n  Vec3%s,\n  Vec3%s\n)',
    transform.left,
    transform.up,
    transform.forward,
    transform.trans
  )

end)

Console:Register('position', "Prints the player's current position", function(args)

  local player = PlayerManager:GetLocalPlayer()

  if player.soldier == nil or not player.soldier.isAlive then
    return 'The player is current not alive'
  end

  local transform = player.soldier.transform

  return string.format('Vec3%s',transform.trans)
end)

end

local registerLobbyCommands = function(lobby)

  Console:Register('refresh', 'Refreshes the match list', function(args)
    lobby:_refresh()
  end)

  Console:Register('list', 'Prints a list of available matches', function(args)

    local mapIds = { }

    for k,_ in pairs(lobby.matches) do
      table.insert(mapIds, k)
    end

    print('Available matches: ' .. table.concat(mapIds), ', ')

  end)

  Console:Register('join', 'Joins the match given a mapId and team', function(args)

    if #args ~= 2 then 
      return 'Invalid number of arguments specified'
    end

    if args[2] ~= 'US' and args[2] ~= 'RU' then
      return 'Invalid team specified'
    end

    local team = args[2] == 'US' and Team.US or Team.RU

    local data = {
      mapId = args[1],
      team = team
    }

    lobby:_joinMatch(json.encode(data))

  end)

  Console:Register('leave', 'Leaves the current match',function(args)

    lobby:_leaveMatch()

  end)

end

return {
  registerSetupCommands = registerSetupCommands,
  registerLobbyCommands = registerLobbyCommands
}
