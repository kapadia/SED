Spine = require('spine')
Sed   = require('models/SpectralEnergyDistribution')

class Examine extends Spine.Controller
  elements:
    "#sed-plot" : 'sed'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Sed.find(id)
    $("#results").remove()
    @render()

  render: =>
    @html require('views/examine')(@item)
    @examine()
    @

  examine: ->
    xmin = Math.log(360)
    xmax = Math.log(4800)

    options =
      points:
        show: true
      xaxis:
        min: xmin
        max: xmax
    $.plot(@sed, [@item.fluxes], options)

module.exports = Examine