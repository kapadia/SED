Spine = require('spine')

class SpectralEnergyDistribution extends Spine.Model
  @configure 'SpectralEnergyDistribution', 'objid', 'fluxes'
  
module.exports = SpectralEnergyDistribution