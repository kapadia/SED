Spine = require('spine')

class SpectralEnergyDistribution extends Spine.Model
  @configure 'SpectralEnergyDistribution', 'objid', 'ra', 'dec', 'fluxDensities', 'bibCode', 'names', 'data'
  @centralWavelengths = {'U': 365, 'B': 445, 'V': 551, 'R': 658, 'I': 806, 'Z': 900, 'Y': 1020, 'J': 1220, 'H': 1630, 'K': 2190, 'L': 3450, 'M': 4750}

  generateData: =>
    data = []
    for key, value of @fluxDensities
      data.push [SpectralEnergyDistribution.centralWavelengths[key], value]
    @updateAttribute("data", data)

module.exports = SpectralEnergyDistribution