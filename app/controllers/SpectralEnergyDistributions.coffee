Spine = require('spine')

class SpectralEnergyDistributions extends Spine.Controller
  constructor: ->
    super

  render: =>
    @append require('views/SpectralEnergyDistribution')(@item)
    @

  drawPlot: ->
    xmin = Math.log(360)
    xmax = Math.log(4800)

    options =
      points:
        show: true
      xaxis:
        min: xmin
        max: xmax
        # transform: (v) -> 
        #   console.log Math.log(v)
        #   return Math.log(v)
    $.plot($("#sed_#{@item.id}"), [@item.fluxes], options)

module.exports = SpectralEnergyDistributions