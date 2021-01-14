local Team = require('__shared/team')

local Spawning = class('Spawning')

local SoldierAsset = { 
  [Team.US] = 'Gameplay/Kits/USAssault',
  [Team.RU] = 'Gameplay/Kits/RUAssault'
}

local SoldierAppearance = {
  [Team.US] = 'Persistence/Unlocks/Soldiers/Visual/MP/Us/MP_US_Assault_Appearance01',
  [Team.RU] = 'Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance01',
}

local KNIFE = 'Weapons/Knife/U_Knife'

local Slot = {
  [1] = WeaponSlot.WeaponSlot_0,
  [2] = WeaponSlot.WeaponSlot_1,
  [3] = WeaponSlot.WeaponSlot_2,
  [4] = WeaponSlot.WeaponSlot_3,
  [5] = WeaponSlot.WeaponSlot_4,
  [6] = WeaponSlot.WeaponSlot_5,
  [7] = WeaponSlot.WeaponSlot_6,
  [8] = WeaponSlot.WeaponSlot_7,
  [9] = WeaponSlot.WeaponSlot_8,
  [10] = WeaponSlot.WeaponSlot_9
}

local selectWeapon = function(player, weaponSlot, weapon, attachments)

  local weaponContainer = ResourceManager:SearchForDataContainer(weapon)
  local attachmentContainers = {}

  if attachments ~= nil then

    for _, att in pairs(attachments) do
      local container = ResourceManager:SearchForDataContainer(att);

      table.insert(attachmentContainers, container)
    end

  end

  player:SelectWeapon(weaponSlot, weaponContainer, attachmentContainers)

end

Spawning.static.spawnSoldier =  function(player, loadout, transform, team)

  selectWeapon(player, WeaponSlot.WeaponSlot_0, loadout.primary.weapon.name, loadout.primary.attachments)

  if loadout.secondary ~= nil then
    selectWeapon(player, WeaponSlot.WeaponSlot_1, loadout.secondary.weapon.name, loadout.secondary.attachments)
  end

  if loadout.accessories ~= nil and #loadout.accessories > 0 then

    selectWeapon(player, Slot[3], loadout.accessories[1].name, {})

    if #loadout.accessories > 1 then
      selectWeapon(player, Slot[6], loadout.accessories[2].name, {})
    end
  end

  selectWeapon(player, Slot[8], KNIFE, {})

  local soldierAsset = ResourceManager:SearchForDataContainer(SoldierAsset[team])
  local appearance = ResourceManager:SearchForDataContainer(SoldierAppearance[team])

  player:SelectUnlockAssets(soldierAsset, { appearance })

  local soldierBlueprint = ResourceManager:SearchForDataContainer('Characters/Soldiers/MpSoldier')

  local soldier = player:CreateSoldier(soldierBlueprint, transform)

  if soldier == nil then
    print('Unable to create soldier')
    return
  end

  player:SpawnSoldierAt(soldier, transform, CharacterPoseType.CharacterPoseType_Stand)

end

return Spawning