local UI_SPAWN_MENU_MP_LOGIC = Guid('0A593B0E-6670-11E0-8215-820026059936')
local UI_INGAME_DIMMER_REFERENCE = Guid('FBCEAF95-2E3D-49CD-9D4F-AC494BE11881')

ResourceManager:RegisterInstanceLoadHandler(UI_SPAWN_MENU_MP_LOGIC, UI_INGAME_DIMMER_REFERENCE, function(instance)
  local logicReference = LogicReferenceObjectData(instance)

  logicReference:MakeWritable()
  logicReference.excluded = true

  print('Visual environment disabled')
end)