Hooks:Install('Client:UpdateFirstPersonTransform', 1, function(hook, transform)

  local me = PlayerManager:GetLocalPlayer()

  if me == nil or me.corpse == nil then
      return
  end

  --hook:Return()

end)