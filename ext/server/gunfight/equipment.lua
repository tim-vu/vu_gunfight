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
  },
  P90 = {
    displayName = 'P90',
    name = 'Weapons/P90/U_P90',
    category = 'TODO',
    imageUrl = 'fb://UI/Art/Persistence/Weapons/P90'
  },
  MP412REX = {
    displayName = 'MP412 Rex',
    name = 'Weapons/MP412Rex/U_MP412Rex',
    category = 'Pistol',
    imageUrl = 'fb://UI/Art/Persistence/Weapons/MP412Rex'
  }

}

local ACCESSORIES = {
  KNIFE = {
    displayName = 'Knife',
    name = "Weapons/Knife/U_Knife",
  },
  CROSSBOW = {
    displayName = 'XBOW',
    name = 'Weapons/XP4_Crossbow_Prototype/U_Crossbow_Scoped_Cobra',
  },
  C4 = {
    displayName = 'C4',
    name = 'Weapons/Gadgets/C4/U_C4',
  },
  CLAYMORE = {
    displayName = 'Claymore',
    name = 'Weapons/Gadgets/Claymore/',
  }
}

local ATTACHMENTS = {

  M98B = {
    RIFLE_SCOPE = 'Weapons/Model98B/U_M98B_Rifle_Scope'
  },
  M16A4 = {
    FOREGRIP = 'Weapons/M16A4/U_M16A4_Foregrip',
    HEAVY_BARREL = 'Weapons/M16A4/U_M16A4_HeavyBarrel',
    RED_DOT = 'Weapons/M16A4/U_M16A4_RX01'
  }

}

Equipment.static.LOADOUTS = {
  {
    primary = {
      weapon = WEAPONS.M98B,
      attachments = {
        ATTACHMENTS.M98B.RIFLE_SCOPE
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
        ATTACHMENTS.M16A4.FOREGRIP,
        ATTACHMENTS.M16A4.RED_DOT,
        ATTACHMENTS.M16A4.HEAVY_BARREL
      }
    },
    secondary = {
      weapon = WEAPONS.M9,
      attachments = {

      }
    },
    accessories = {
      ACCESSORIES.KNIFE,
      ACCESSORIES.CROSSBOW
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
    },
    accessories = {
      ACCESSORIES.C4
    }
  },
  {
    primary = {
      weapon = WEAPONS.R870,
      attachments = {

      }
    },
    secondary = {
      weapon = WEAPONS.MP412REX,
      attachments = {

      }
    }
  }
}

return Equipment

