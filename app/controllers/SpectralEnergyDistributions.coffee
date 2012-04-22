SED           ?= require('models/SpectralEnergyDistribution')
PlotSettings  = require('controllers/PlotSettings')

class SpectralEnergyDistributions extends Spine.Controller
  @extend PlotSettings

  constructor: ->
    super
    @item.generateData()

  render: (small = true) =>
    if small
      viewSize = 'small'
      element = $("#seds")
    else
      viewSize = 'large'
      element = @el
    element.append require("views/sed-#{viewSize}")(@item)
    @plot(small)
    @

  plot: (small) =>
    if small
      container = $("##{@item.cid}")
      container.bind("mouseenter", @redraw)
      container.bind("mouseleave", @redraw)
      data = SpectralEnergyDistributions.dataSmallOptions
      data[0]['data'] = @item.data
      options = SpectralEnergyDistributions.plotSmallOptions
    else
      container = $("#examine .plot")
      data = SpectralEnergyDistributions.dataLargeOptions
      data[0]['data'] = @item.data
      options = SpectralEnergyDistributions.plotLargeOptions
    $.plot(container, data, options)

    container.bind("plothover", (evt, position, item) ->
      if item
        $("#cursor").remove()
        x = item.datapoint[0].toFixed(2)
        y = item.datapoint[1].toFixed(2)
        SpectralEnergyDistributions.cursorInfoStyle['left'] = item.pageX + 16
        SpectralEnergyDistributions.cursorInfoStyle['top'] =  item.pageY + 8
        $("<div id='cursor'>#{x} Jy, #{y} nm</div>").css(SpectralEnergyDistributions.cursorInfoStyle).appendTo("#examine").show()
      else
        $("#cursor").remove()
    )

  redraw: (e) ->
    cid = e.currentTarget.id
    sed = SED.find(cid)

    options = SpectralEnergyDistributions.plotSmallOptions
    data =
      data: sed.data
      color: "#505050"

    if e.type is "mouseenter"
      options['xaxis']['color'] = '#C34E00'
      options['yaxis']['color'] = '#C34E00'
      data['color'] = '#C34E00'

    $.plot(@, data, options)

module.exports = SpectralEnergyDistributions