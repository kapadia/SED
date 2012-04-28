Spine = require('spine')

class SpectralEnergyDistribution extends Spine.Model
  @configure 'SpectralEnergyDistribution', 'objid', 'ra', 'dec', 'fluxDensities', 'bibCodes', 'names', 'type', 'data'
  @centralWavelengths = {
    'U': 365, 'B': 445, 'V': 551, 'R': 658, 'I': 806, 'Z': 900, 'Y': 1020, 'J': 1220, 'H': 1630, 'K': 2190, 'L': 3450, 'M': 4750,
    '12um': 12000, '25um': 25000, '60um': 60000, '100um': 100000
  }

  @getTypes: ->
    seds = @all()
    types = []
    for sed in seds
      types.push(sed.type) unless sed.type in types
    return types

  generateData: =>
    data = []
    for key, value of @fluxDensities
      data.push [SpectralEnergyDistribution.centralWavelengths[key], value]

    @updateAttribute("data", data)

  @micron2nanometers: (length) -> return length * 1000

  decimalToSexagesimal: ->
    ra = @ra / 15
    raHours     = parseInt(ra)
    raMinutes   = parseInt(ra % 1 * 60)
    raSeconds   = (ra % 1 * 60) % 1 * 60
    sign        = if parseInt(Math.abs(@dec) / @dec) > 0 then "+" else "-"
    dec         = Math.abs(@dec)
    decDegrees  = parseInt(dec)
    decMinutes  = parseInt(dec % 1 * 60)
    decSeconds  = (dec % 1 * 60) % 1 * 60
    return ["#{raHours}:#{raMinutes}:#{raSeconds.toFixed(3)}", "#{sign}#{decDegrees}:#{decMinutes}:#{decSeconds.toFixed(3)}"]


module.exports = SpectralEnergyDistribution