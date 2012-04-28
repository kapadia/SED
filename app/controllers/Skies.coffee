ChromoscopeSettings  = require('modules/ChromoscopeSettings')

class Skies extends Spine.Controller
  @extend ChromoscopeSettings

  constructor: ->
    super

  render: =>
    @append require("views/sky")(@item)
    @setupChromoscope()
    @

  setupChromoscope: ->
    @chromoscope = $.chromoscope Skies.settings
    @chromoscope.addWavelength(Skies.gamma)
    @chromoscope.addWavelength(Skies.xray)
    @chromoscope.addWavelength(Skies.optical)
    @chromoscope.addWavelength(Skies.halpha)
    @chromoscope.addWavelength(Skies.nearir)
    @chromoscope.addWavelength(Skies.farir)
    @chromoscope.addWavelength(Skies.microwave)
    @chromoscope.addWavelength(Skies.radio)
    @chromoscope.load()

module.exports = Skies