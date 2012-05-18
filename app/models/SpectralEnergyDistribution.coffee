Spine = require('spine')
SimbadTaxonomy = require('modules/SimbadTaxonomy')
NedTaxonomy = require('modules/NedTaxonomy')

class SpectralEnergyDistribution extends Spine.Model
  @configure 'SpectralEnergyDistribution', 'origin', 'objid', 'ra', 'dec', 'fluxDensities', 'bibCodes', 'names', 'type', 'data'
  @centralWavelengths = {
    'U': 365, 'B': 445, 'V': 551, 'R': 658, 'I': 806, 'Z': 900, 'Y': 1020, 'J': 1220, 'H': 1630, 'K': 2190, 'L': 3450, 'M': 4750,
    '12um': 12000, '25um': 25000, '60um': 60000, '100um': 100000, 'u': 354.3, 'g': 477.0, 'r': 623.1, 'i': 762.5, 'z': 913.4,
    '3.6um': 3600, '4.5um': 4500, '5.8um': 5800, '8.0um': 8000,
    '2.3keV': 0.539, '0.4keV': 3.1, '0.92keV': 1.3, '1.56keV': 0.795, '3.8keV': 0.326,
    'J_twomass': 1250, 'H_twomass': 1650, 'K_s_twomass': 2170, '0.2-12.0keV': 0.21,
    '1.4GHz': 210000000
  }
  @lookup = {}

  constructor: ->
    super

    if @origin is 'NED'
      # Format coordinates if we receive a string (e.g. from NED)
      if typeof(@ra) is "string"
        coords = @ra.match(/(\d{2})\s*(\d{2})\s*(\d+.\d*)\s(-*\d{2})\s*(\d{2})\s*(\d+.\d*)\s*\((J2000|B1950)\)/)
        hh_ra   = parseFloat(coords[1])
        mm_ra   = parseFloat(coords[2])
        ss_ra   = parseFloat(coords[3])
        dd_dec  = parseFloat(coords[4])
        mm_dec  = parseFloat(coords[5])
        ss_dec  = parseFloat(coords[6])
        equinox = coords[7]
        ra = SpectralEnergyDistribution.hhmmss2degrees(hh_ra, mm_ra, ss_ra)
        dec = SpectralEnergyDistribution.ddmmss2degrees(dd_dec, mm_dec, ss_dec)
        [ra, dec] = SpectralEnergyDistribution.B1950toJ2000(ra, dec) if equinox is "B1950"
        @ra = ra
        @dec = dec

      @getObjectType = =>
        return if NedTaxonomy[@type]? then NedTaxonomy[@type] else @type

      @generateData = =>
        data = []
        for key, value of @fluxDensities
          data.push [parseFloat(key), value]
        @updateAttribute("data", data)

    else
      @getObjectType = =>
        return if SimbadTaxonomy[@type]? then SimbadTaxonomy[@type] else @type

      @generateData = =>
        data = []
        for key, value of @fluxDensities
          data.push [SpectralEnergyDistribution.centralWavelengths[key], value]
        @updateAttribute("data", data)

    if @names
      for name in @names
        SpectralEnergyDistribution.lookup[name] = @id unless @name in @names

  @getTypes: ->
    seds = @all()
    types = []
    for sed in seds
      types.push(sed.type) unless sed.type in types
    return types

  min: ->
    console.log 'min'

  max: ->
    console.log 'max'

  @B1950toJ2000: (ra, dec) ->
    precessionMatrix = [
      [  9.99925709e-01, 1.11788915e-02, 4.85898348e-03],
      [ -1.11788915e-02, 9.99937514e-01, -2.71576991e-05],
      [ -4.85898345e-03, -2.71623675e-05, 9.99988195e-01]
    ]
    
    ra  = ra * Math.PI / 180
    dec = dec * Math.PI / 180
    
    # Convert ra and dec to rectangular coordinates
    x = Math.cos(ra) * Math.cos(dec)
    y = Math.sin(ra) * Math.cos(dec)
    z = Math.sin(dec)
    
    # Apply the precession matrix
    x2 = precessionMatrix[0][0] * x + precessionMatrix[1][0] * y + precessionMatrix[2][0] * z
    y2 = precessionMatrix[0][1] * x + precessionMatrix[1][1] * y + precessionMatrix[2][1] * z
    z2 = precessionMatrix[0][2] * x + precessionMatrix[1][2] * y + precessionMatrix[2][2] * z
    
    # Convert the new rectangular coordinates back to RA, Dec
    ra  = Math.atan2(y2, x2)
    dec = Math.asin(z2)
    
    ra  = ra * 180 / Math.PI
    dec = dec * 180 / Math.PI
    
    ra  = ra % 360
    dec = (dec + 90) % 180 - 90
    
    return [ra, dec]

  @decimalToSexagesimal: (ra, dec)->
    ra = ra / 15
    raHours     = parseInt(ra)
    raMinutes   = parseInt(ra % 1 * 60)
    raSeconds   = (ra % 1 * 60) % 1 * 60
    sign        = if parseInt(Math.abs(dec) / dec) > 0 then "+" else "-"
    dec         = Math.abs(dec)
    decDegrees  = parseInt(dec)
    decMinutes  = parseInt(dec % 1 * 60)
    decSeconds  = (dec % 1 * 60) % 1 * 60
    return ["#{raHours}:#{raMinutes}:#{raSeconds.toFixed(3)}", "#{sign}#{decDegrees}:#{decMinutes}:#{decSeconds.toFixed(3)}"]

  @hhmmss2degrees: (hh, mm, ss) -> return hh * 15 + mm / 4 + ss / 240

  @ddmmss2degrees: (dd, mm, ss) ->
    sign = if dd < 0 then -1 else 1
    return sign * Math.abs(dd) + (5 * mm / 3 + 5 * ss / 180) / 100

module.exports = SpectralEnergyDistribution