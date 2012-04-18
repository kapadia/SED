require('lib/setup')

Spine   = require('spine')
Main    = require('controllers/Main')
Seds    = require('controllers/SpectralEnergyDistributions')
Examine = require('controllers/Examine')

class App extends Spine.Stack
  className: 'seds stack'

  controllers:
    main    : Main
    seds    : Seds
    examine : Examine

  routes:
    '/'         : 'main'
    '/seds/:id' : 'examine'

  default: 'main'

  constructor: ->
    super

module.exports = App