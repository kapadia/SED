Spine = require('spine')
Sed   = require('models/SpectralEnergyDistribution')

class Examine extends Spine.Controller
  elements:
    "#sed-plot" : 'sed'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Sed.find(id)
    $("#results").remove()
    @render()

  render: =>
    @html require('views/examine')(@item)
    @examine()
    @

  examine: ->
    @plot()
    # @sky()

  plot: ->
    xmin = Math.log(360)
    xmax = Math.log(4800)

    options =
      points:
        show: true
      xaxis:
        min: xmin
        max: xmax
    $.plot(@sed, [@item.fluxes], options)

  sky: ->
    @chromoscope = $.chromoscope({container: '#sky', lang:'es', showintro: false, compact: true})
    @chromoscope.addWavelength({key:'g',useasdefault:false,name:'gamma',tiles:'http://astrog80.astro.cf.ac.uk/Chromoscope/fermi-tiles/',ext:'jpg',title:'gamma',attribution:'<a href="http://fermi.gsfc.nasa.gov/">Fermi</a>'})
    @chromoscope.addWavelength({key:'x',useasdefault:false,name:'xray',tiles:'http://s3.amazonaws.com/chromoscope-RASS-tiles/',ext:'jpg',title:'xray',attribution:'<a href="http://www.mpe.mpg.de/xray/wave/rosat/index.php">ROSAT</a>'})
    @chromoscope.addWavelength({key:'v',useasdefault:true,name:'optical',tiles:{z:'http://s3.amazonaws.com/chromoscope-DSS2-tiles/',z3:'http://s3.amazonaws.com/chromoscope-photopic/',z4:'http://s3.amazonaws.com/chromoscope-photopic/'},ext:'jpg',title:'optical',attribution:{z:'<a href="http://stdatu.stsci.edu/dss/">DSS2</a>/<a href="http://www.wikisky.org/">Wikisky</a>',z3:'Nick Risinger, <a href="http://skysurvey.org/">skysurvey.org</a>',z4:'Nick Risinger, <a href="http://skysurvey.org/">skysurvey.org</a>'}})
    @chromoscope.addWavelength({key:'a',useasdefault:false,name:'halpha',tiles:'http://s3.amazonaws.com/chromoscope-H-alpha-tiles/',ext:'jpg',title:'halpha',attribution:'<a href="http://www.astro.wisc.edu/wham/">WHAM</a>/<a href="http://www.phys.vt.edu/~halpha/">VTSS</a>/<a href="http://amundsen.swarthmore.edu/">SHASSA</a>/<a href="http://www.cfa.harvard.edu/~dfinkbei/">Finkbeiner</a>'})
    @chromoscope.addWavelength({key:'n',useasdefault:false,name:'nearir',tiles:'http://astrog80.astro.cf.ac.uk/Chromoscope/WISE-tiles/',ext:'jpg',title:'Near-Infrared',attribution:'<a href="http://wise.ssl.berkely.edu/IRASdocs/iras.html">WISE</a>/NASA/JPL-Caltech/UCLA'})
    @chromoscope.addWavelength({key:'f',useasdefault:false,name:'farir',tiles:'http://s3.amazonaws.com/chromoscope-IRAS-tiles/',ext:'jpg',title:'farir',attribution:'<a href="http://irsa.ipac.caltech.edu/IRASdocs/iras.html">IRAS</a>/NASA'})
    @chromoscope.addWavelength({key:'m',useasdefault:false,name:'microwave',tiles:'http://s3.amazonaws.com/chromoscope-Planck-FSM-tiles/',ext:'jpg',title:'microwave',attribution:'<a href="http://www.esa.int/esaCP/SEMF2FRZ5BG_index_0.html">ESA Planck</a> LFI and HFI Consortia (2010)'})
    @chromoscope.addWavelength({key:'r',useasdefault:false,name:'radio',tiles:'http://s3.amazonaws.com/chromoscope-Radio_vsmoothed-tiles/',ext:'jpg',title:'radio',attribution:'<a href="http://lambda.gsfc.nasa.gov/product/foreground/haslam_408.cfm">Haslam et al.</a>'})
    @chromoscope.load()

module.exports = Examine