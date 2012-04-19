Spine = require('spine')

class SpectralEnergyDistributions extends Spine.Controller
  constructor: ->
    super
    @item.generateData()

  render: =>
    @append require('views/sed')(@item)
    @plot()
    @

  plot: =>
    xmin = Math.log(360)
    xmax = Math.log(4800)
    options = 
      points:
        show: true
    $.plot($("##{@item.cid}"), [@item.data], options)

module.exports = SpectralEnergyDistributions