local Equipment = class('Equipment')

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
  },
  M16A4 = {
    displayName = 'M16A4',
    name = 'Weapons/M16A4/U_M16A4',
    category = 'Assault rifle',
    imageUrl = 'fb://UI/Art/Persistence/Weapons/M16A4'
  },
  M9 = {
    displayName = 'M9',
    name = 'Weapons/M9/U_M9',
    category = 'Pistol',
    imageUrl = 'fb://UI/Art/Persistence/Weapons/M9'
  },
  ASVAL = {
    displayName = 'AS Val',
    name = 'Weapons/ASVal/U_ASVal',
    category = 'Assault rifle',
    imageUrl = 'fb://UI/Art/Persistence/Weapons/ASVal'
  },
  G17 = {
    displayName = 'G17',
    name = 'Weapons/Glock17/U_Glock17',
    category = 'Pistol',
    imageUrl = 'fb://UI/Art/Persistence/Weapons/Glock17'
  },
  UMP45 = {
    displayName = 'UMP45',
    name = 'Weapons/UMP45/U_UMP45',
    category = 'TODO',
    imageUrl = 'fb://UI/Art/Persistence/Weapons/UMP'
  },
  MAGNUM = {
    displayName = '.44 Magnum',
    name = 'Weapons/Taurus44/U_Taurus44',
    category = 'Pistol',
    imageUrl = 'fb://UI/Art/Persistence/Weapons/Taurus44'
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

Equipment.static.LOADOUTS = {
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
  },
  {
    primary = {
      weapon = WEAPONS.M16A4,
      attachments = {

      }
    },
    secondary = {
      weapon = WEAPONS.M9,
      attachments = {

      }
    }
  },
  {
    primary = {
      weapon = WEAPONS.ASVAL,
      attachments = {

      }
    },
    secondary = {
      weapon = WEAPONS.G17,
      attachments = {

      }
    }
  },
  {
    primary = {
      weapon = WEAPONS.UMP45,
      attachments = {

      }
    },
    secondary = {
      weapon = WEAPONS.MAGNUM,
      attachments = {

      }
    }
  }
}

return Equipment

