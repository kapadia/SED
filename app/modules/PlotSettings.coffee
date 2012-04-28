PlotSettings =
  ticks: [ [365,'U'], [445, 'B'], [551, 'V'], [658, 'R'], [806, 'I'], [900, 'Z'], [1020, 'Y'], [1220, 'J'], [1630, 'H'], [2190, 'K'], [3450, 'L'], [4750, 'M']]

  markings: () ->
    m = []
    for band in @ticks
      option = 
        color: "rgba(255, 0, 0, 0.2)"
        lineWidth: 0.5
        xaxis:
          from: band[0] - 0.5
          to: band[0] + 0.5
      m.push option
    console.log 'markings', m
    return m

  plotSmallOptions:
    points:
      show: true
      radius: 1
    grid:
      labelMargin: 12
    xaxis:
      tickDecimals: 0
      autoscaleMargin: 0.1
    yaxis:
      ticks: 2
      tickDecimals: 2
      autoscaleMargin: 0.1
  
  dataSmallOptions: [
    color: "#505050"
  ]

  plotLargeOptions:
    points:
      show: true
      fill: true
    xaxes: [
      position: 'top'
      ticks: [ [365,'U'], [445, 'B'], [551, 'V'], [658, 'R'], [806, 'I'], [900, 'Z'], [1020, 'Y'], [1220, 'J'], [1630, 'H'], [2190, 'K'], [3450, 'L'], [4750, 'M']]
    ,
      position: 'bottom'
    ]
    grid:
      markings: [
        color: 'rgba(255, 0, 0, 0.1)'
        lineWidth: 0.5
        xaxis:
          from: 445 - 0.5
          to: 445 + 0.5
      ,
        color: 'rgba(255, 0, 0, 0.1)'
        lineWidth: 0.5
        xaxis:
          from: 551 - 0.5
          to: 551 + 0.5
      ,
        color: 'rgba(255, 0, 0, 0.1)'
        lineWidth: 0.5
        xaxis:
          from: 658 - 0.5
          to: 658 + 0.5
      ,
        color: 'rgba(255, 0, 0, 0.1)'
        lineWidth: 0.5
        xaxis:
          from: 806 - 0.5
          to: 806 + 0.5
      ,
        color: 'rgba(255, 0, 0, 0.1)'
        lineWidth: 0.5
        xaxis:
          from: 900 - 0.5
          to: 900 + 0.5
      ,
        color: 'rgba(255, 0, 0, 0.1)'
        lineWidth: 0.5
        xaxis:
          from: 1020 - 0.5
          to: 1020 + 0.5
      ,
        color: 'rgba(255, 0, 0, 0.1)'
        lineWidth: 0.5
        xaxis:
          from: 1220 - 0.5
          to: 1220 + 0.5
      ,
        color: 'rgba(255, 0, 0, 0.1)'
        lineWidth: 0.5
        xaxis:
          from: 1630 - 0.5
          to: 1630 + 0.5
      ,
        color: 'rgba(255, 0, 0, 0.1)'
        lineWidth: 0.5
        xaxis:
          from: 2190 - 0.5
          to: 2190 + 0.5
      ,
        color: 'rgba(255, 0, 0, 0.1)'
        lineWidth: 0.5
        xaxis:
          from: 3450 - 0.5
          to: 3450 + 0.5
      ,
        color: 'rgba(255, 0, 0, 0.1)'
        lineWidth: 0.5
        xaxis:
          from: 4750 - 0.5
          to: 4750 + 0.5
      ]
      hoverable: true,
      labelMargin: 14
      axisMargin: 10

  dataLargeOptions: [
    xaxis: 1
  ,
    color: '#505050'
    points:
      show: true
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