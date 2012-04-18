Spine = require('spine')
Sed   = require('models/SpectralEnergyDistribution')

class Examine extends Spine.Controller
  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Sed.find(id)
    $("#results").empty()
    @render()

  render: =>
    @html require('views/examine')(@item)
    @

module.exports = Examine