require('__shared/math/rectangle')
local Team = require('__shared/team')

return {

  NOSHAR_CANALS = {
    name = 'Noshar Canals',
    spawnpoints = {
      A = {
        LinearTransform(
          Vec3(0.781778, 0.000000, -0.623557),
          Vec3(0.000000, 1.000000, 0.000000),
          Vec3(0.623557, 0.000000, 0.781778),
          Vec3(-351.661133, 70.434372, 241.824219)
        ),
        LinearTransform(
          Vec3(0.617119, 0.000000, -0.786870),
          Vec3(0.000000, 1.000000, 0.000000),
          Vec3(0.786870, 0.000000, 0.617119),
          Vec3(-354.113281, 70.434372, 244.070313)
        )
      },
      B = {
        LinearTransform(
          Vec3(-0.768923, 0.000000, 0.639342),
          Vec3(0.000000, 1.000000, 0.000000),
          Vec3(-0.639342, 0.000000, -0.768923),
          Vec3(-317.896484, 70.434372, 288.468750)
        ),
        LinearTransform(
          Vec3(-0.643199, 0.000000, 0.765699),
          Vec3(0.000000, 1.000000, 0.000000),
          Vec3(-0.765699, 0.000000, -0.643199),
          Vec3(-315.387695, 70.434372, 285.718750)
        )
      }
    },
    --Vec3(-321.534180, 70.438278, 301.490234)
    --Vec3(-342.638672, 70.434372, 217.917969)
    area = Rectangle(-380.638672, 217.917969, -304.534180, 330.490234)
  }

}