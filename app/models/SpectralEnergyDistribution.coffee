Spine = require('spine')

class SpectralEnergyDistribution extends Spine.Model
  @configure 'SpectralEnergyDistribution', 'objid', 'ra', 'dec', 'fluxDensities', 'bibCodes', 'names', 'type', 'misc', 'data'
  @centralWavelengths = {
    'U': 365, 'B': 445, 'V': 551, 'R': 658, 'I': 806, 'Z': 900, 'Y': 1020, 'J': 1220, 'H': 1630, 'K': 2190, 'L': 3450, 'M': 4750,
    '12um': 12000, '25um': 25000, '60um': 60000, '100um': 100000, 'u': 354.3, 'g': 477.0, 'r': 623.1, 'i': 762.5, 'z': 913.4,
    '3.6um': 3600, '4.5um': 4500, '5.8um': 5800, '8.0um': 8000,
    '2.3keV': 0.539, '0.4keV': 3.1, '0.92keV': 1.3, '1.56keV': 0.795, '3.8keV': 0.326,
    'J_twomass': 1250, 'H_twomass': 1650, 'K_s_twomass': 2170, '0.2-12.0keV': 0.21
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

  min: ->
    console.log 'min'

  max: ->
    console.log 'max'
  
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