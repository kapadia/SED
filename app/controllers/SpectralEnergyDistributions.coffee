Spine = require('spine')
SED   = require('models/SpectralEnergyDistribution')

class SpectralEnergyDistributions extends Spine.Controller
  constructor: ->
    super
    @item.generateData()

  render: (small = true) =>
    viewSize = if small then 'small' else 'large'
    @append require("views/sed-#{viewSize}")(@item)
    @plot(small)
    @

  plot: (small) =>
    if small
      container = $("##{@item.cid}")
      data = [ {data: @item.data, color: "#505050"} ]
      options = 
        points:
          show: true
    else
      container = $("#examine .plot")
      data = [
        {
          data:       @item.data,
          hoverable:  true,
          color:      "#505050",
          points:
            show: true
          xaxis: 1
        },
        {
          data: @item.data,
          xaxis: 2
        }
      ]
      markings = []
      ticks = []
      for label, wavelength of SED.centralWavelengths
        markings.push({ color: "rgba(255, 0, 0, 0.1)", lineWidth: 0.5, xaxis: { from: wavelength - 0.25, to: wavelength + 0.25 } })
        ticks.push([wavelength, label])

      options = 
        points:
          show: true
        xaxes: [ {axisLabel: "Wavelength (nm)", position: 'bottom'}, {position: 'top', ticks : ticks} ]
        yaxes: [ {axisLabel: "Flux Density (Jy)"}]
        grid:
          markings: markings
          hoverable: true,
          clickable: true
          labelMargin: 14
          axisMargin: 10

    $.plot(container, data, options)

    container.bind("plothover", (evt, position, item) ->
      if item
        $("#cursor").remove()
        x = item.datapoint[0].toFixed(2)
        y = item.datapoint[1].toFixed(2)
        $("<div id='cursor'>#{x} Jy, #{y} nm</div>").css({
                    position: 'fixed',
                    display: 'none',
                    left: item.pageX + 16,
                    top: item.pageY + 8,
                    border: '1px solid #FDD',
                    padding: '2px',
                    'background-color': '#FEE',
                    opacity: 0.80
                }).appendTo("#sed-plot").show()
      else
        $("#cursor").remove()
    )

module.exports = SpectralEnergyDistributions