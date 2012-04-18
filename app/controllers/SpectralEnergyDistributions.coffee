Spine = require('spine')

class SpectralEnergyDistributions extends Spine.Controller
  constructor: ->
    super
  
  generateURL: ->
    console.log 'generateURL'

  requestFromSimbad: ->
    console.log 'requestFromSimbad'

module.exports = SpectralEnergyDistributions