local WEAPONS = {
  M98B = {
    displayName = 'M98B',
    name = 'Weapons/Model98B/U_M98B',
    category = 'Sniper rifle',
    imageUrl = 'fb://UI/Art/Persistence/Weapons/M98'
  },
  R870 = {
    displayName = '870MCS',
    name = "Weapons/Remington870/U_870",
    category = 'Shotgun',
    imageUrl = 'fb://UI/Art/Persistence/Weapons/Remington'
  }
}

local ACCESSORIES = {
  KNIFE = {
    displayName = 'Knife',
    name = "Weapons/Knife/U_Knife",
    category = 'Melee',
    imageUrl = 'fb://UI/Art/Persistence/Weapons/Knife_small'
  }
}

local ATTACHMENTS = {

  M98B = {
    rifleScope = 'Weapons/Model98B/U_M98B_Rifle_Scope'
  }

}

LOADOUTS = {
  {
    primary = { 
      weapon = WEAPONS.M98B,
      attachments = {
        ATTACHMENTS.M98B.rifleScope
      }
    },
    secondary = {
      weapon = WEAPONS.R870,
      attachments = {}
    },
    accessories = {
      ACCESSORIES.KNIFE
    }
  }
}

