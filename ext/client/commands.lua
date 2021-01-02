local Team = require('__shared/team')

local registerSetupCommands = function()

Console:Register('spawn', 'Spawns the player with the given loadout', function(args)

  if #args ~= 1 then
    return 'Invalid amount of arguments specified'
  end

  NetEvents:Send('Spawn', args[1])

end)

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

  Console:Register('ui_init', 'Initializes the ui', function(args)
    WebUI:Init()
    WebUI:BringToFront()
    NetEvents:Send('Lobby:Ready')
  end)

  Console:Register('refresh', 'Refreshes the match list', function(args)
    lobby:_refresh()
  end)

end

return {
  registerSetupCommands = registerSetupCommands,
  registerLobbyCommands = registerLobbyCommands
}
