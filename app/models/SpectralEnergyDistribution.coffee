Spine = require('spine')

class SpectralEnergyDistribution extends Spine.Model
  @configure 'SpectralEnergyDistribution', 'objid', 'fluxes', 'globalMin', 'globalMax', 'count'

  pluralize: -> return 'SpectralEnergyDistributions'

module.exports = SpectralEnergyDistribution