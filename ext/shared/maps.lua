require('__shared/math/rectangle')
require('__shared/math/polygon')
local Equipment = require('__shared/equipment')

local loadouts = {
  {
    primary = {
      weapon = Equipment.WEAPONS.M98B,
      attachments = {
        Equipment.ATTACHMENTS.M98B.RIFLE_SCOPE
      }
    },
    secondary = {
      weapon = Equipment.WEAPONS.R870,
      attachments = {}
    },
    accessories = {
      Equipment.ACCESSORIES.CROSSBOW,
      Equipment.ACCESSORIES.C4
    }
  },
  {
    primary = {
      weapon = Equipment.WEAPONS.M16A4,
      attachments = {
        Equipment.ATTACHMENTS.M16A4.FOREGRIP,
        Equipment.ATTACHMENTS.M16A4.RED_DOT,
        Equipment.ATTACHMENTS.M16A4.HEAVY_BARREL
      }
    },
    secondary = {
      weapon = Equipment.WEAPONS.M9,
      attachments = {

      }
    },
    accessories = {
      Equipment.ACCESSORIES.CROSSBOW
    }
  },
  {
    primary = {
      weapon = Equipment.WEAPONS.ASVAL,
      attachments = {

      }
    },
    secondary = {
      weapon = Equipment.WEAPONS.G17,
      attachments = {

      }
    }
  },
  {
    primary = {
      weapon = Equipment.WEAPONS.UMP45,
      attachments = {

      }
    },
    secondary = {
      weapon = Equipment.WEAPONS.MAGNUM,
      attachments = {

      }
    },
    accessories = {
      Equipment.ACCESSORIES.C4
    }
  },
  {
    primary = {
      weapon = Equipment.WEAPONS.R870,
      attachments = {

      }
    },
    secondary = {
      weapon = Equipment.WEAPONS.MP412REX,
      attachments = {

      }
    }
  }

}

return {

  ['METRO_1'] = {
    displayName = 'Metro inside',
    teamSize = 2,
    spawnpoints = {
      A = {
        LinearTransform(
          Vec3(0.999800, 0.000000, -0.019980),
          Vec3(0.000000, 1.000000, 0.000000),
          Vec3(0.019980, 0.000000, 0.999800),
          Vec3(-190.014648, 64.626755, -460.928711)
        ),
        LinearTransform(
          Vec3(0.997848, 0.000000, -0.065563),
          Vec3(0.000000, 1.000000, 0.000000),
          Vec3(0.065563, 0.000000, 0.997848),
          Vec3(-199.462891, 64.629684, -460.416016)
        )
      },
      B = {
        LinearTransform(
          Vec3(-0.999859, 0.000000, 0.016798),
          Vec3(0.000000, 1.000000, 0.000000),
          Vec3(-0.016798, 0.000000, -0.999859),
          Vec3(-198.579102, 64.626755, -386.853516)
        ),
        LinearTransform(
          Vec3(-0.999717, 0.000000, 0.023775),
          Vec3(0.000000, 1.000000, 0.000000),
          Vec3(-0.023775, 0.000000, -0.999717),
          Vec3(-190.234375, 64.626755, -387.193359)
        )
      }
    },
    --Vec3(-164.212891, 59.258595, -363.029297)
    --Vec3(-235.319336, 65.107246, -483.191406)
    area = Polygon(Vec2(-234.930664, -362.305664), Vec2(-156.945313, -367.829102), Vec2(-161.942383, -469.661133), Vec2(-225.328506, -493.438324)),
    loadouts = loadouts
  },
  ['METRO_2'] = {
    displayName = 'Metro street',
    teamSize = 1,
    spawnpoints = {
      A = {
        LinearTransform(
          Vec3(0.002041, 0.000000, 0.999998),
          Vec3(0.000000, 1.000000, 0.000000),
          Vec3(-0.999998, 0.000000, 0.002041),
          Vec3(-216.012695, 64.274216, -505.837891)
        ),
        LinearTransform(
          Vec3(-0.015405, 0.000000, 0.999881),
          Vec3(0.000000, 1.000000, 0.000000),
          Vec3(-0.999881, 0.000000, -0.015405),
          Vec3(-216.140625, 64.274216, -507.835938)
        )
      },
      B = {
        LinearTransform(
          Vec3(-0.029453, 0.000000, -0.999566),
          Vec3(0.000000, 1.000000, 0.000000),
          Vec3(0.999566, 0.000000, -0.029453),
          Vec3(-260.023438, 64.274216, -504.994141)
        ),
        LinearTransform(
          Vec3(-0.029453, 0.000000, -0.999566),
          Vec3(0.000000, 1.000000, 0.000000),
          Vec3(0.999566, 0.000000, -0.029453),
          Vec3(-260.111328, 64.274216, -508.011719)
        )
      }
    },
    --Vec3(-271.088867, 64.524536, -499.358398)
    --Vec3(-212.502930, 65.086716, -517.129883)
    area = Polygon(Vec2(-209.152344, -521.759766), Vec2(-302.777344, -518.741211), Vec2(-305.584961, -494.997070), Vec2(-197.022461, -493.738281)),
    loadouts = loadouts
  }

}