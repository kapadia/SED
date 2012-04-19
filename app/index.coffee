require('lib/setup')

Spine   = require('spine')
Main    = require('controllers/Main')
Results = require('controllers/Results')
Examine = require('controllers/Examine')

class App extends Spine.Stack
  className: "Zooniverse Spectral Energy Distribution"

  controllers:
    main    : Main
    results : Results
    examine : Examine

  routes:
    '/'                         : 'main'
    '/results/:ra/:dec/:radius' : 'results'
    '/results/:id'              : 'examine'

  default: 'main'

  constructor: ->
    super
    Spine.Route.setup()

module.exports = App