PlotSettings =
  ticks: [ [365,'U'], [445, 'B'], [551, 'V'], [658, 'R'], [806, 'I'], [900, 'Z'], [1020, 'Y'], [1220, 'J'], [1630, 'H'], [2190, 'K'], [3450, 'L'], [4750, 'M']]

  markings: ->
    m = []
    for band in @ticks
      option = 
        color: "rgba(255, 0, 0, 0)"
        lineWidth: 0.5
        xaxis:
          from: band[0] - 0.5
          to: band[0] + 0.5
      m.push option
    return m

  plotSmallOptions:
    points:
      show: true
      radius: 1
    grid:
      labelMargin: 12
    xaxis:
      tickDecimals: 0
    yaxis:
      ticks: 2
      tickDecimals: 2
  
  dataSmallOptions: [
    color: "#505050"
  ]

  plotLargeOptions:
    points:
      show: true
    xaxes: [
      axisLabel: "Wavelength (nm)"
      position: 'bottom'
    ,
      position: 'top'
      ticks: @ticks
    ]
    yaxes: [
      axisLabel: "Flux Density (Jy)"
    ]
    grid:
      markings: @markings
      hoverable: true,
      clickable: true
      labelMargin: 14
      axisMargin: 10

  dataLargeOptions: [
    hoverable: true
    color: '#505050'
    points:
      show: true
    xaxis: 1
    ,
    xaxis: 2
  ]

  cursorInfoStyle:
    position: 'fixed'
    display: 'none'
    border: '1px solid #FDD'
    padding: '2px'
    'background-color': '#FEE'
    opacity: 0.80

module.exports = PlotSettings