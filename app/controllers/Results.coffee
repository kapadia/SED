Spine = require('spine')
SED   = require('models/SpectralEnergyDistribution')
SEDs  = require('controllers/SpectralEnergyDistributions')

class Results extends Spine.Controller
  events:
    'click .sed' : 'examine'
  
  constructor: ->
    super

    SED.bind "create", @addSedController

    @active (params) ->
      @change()
      @getData params.ra, params.dec, params.radius

  change: () ->
    @render()

  render: ->
    @html require('views/results')()
    @

  getData: (ra, dec, radius) ->
    $.ajax({
      dataType: 'jsonp',
      url: @generateURL(ra, dec, radius),
      callback: 'givemeseds',
      success: (data) =>
        @noResults() if data.length is 0
        @initializeSedModel(sed) for sed in data
      error: (e) ->
        console.log 'error', e
    })

  generateURL: (ra, dec, radius = 30) ->
    return "http://www.milkywayproject.org/gator.json?radius=#{radius}&ra=#{ra}&dec=#{dec}"

  initializeSedModel: (sed) ->
    params = {}
    params['objid']   = sed['object_name']
    params['ra']      = sed['ra']
    params['dec']     = sed['dec']
    params['bibcode'] = sed['bibcode']
    params['ra']      = sed['ra']
    params['names']   = sed['all_names']
    delete sed['object_name']
    delete sed['ra']
    delete sed['dec']
    delete sed['bibcode']
    delete sed['ra']
    delete sed['all_names']
    params['fluxDensities'] = sed
    model = new SED params
    model.save()

  addSedController: (model) ->
    view = new SEDs {item: model, el: $("#results")}
    view.render()

  back: => Spine.navigate('/') if @.active?

  examine: (e) =>
    cid = $(e.currentTarget).children('.plot').first().attr("id")
    @navigate('/results', cid)

module.exports = Results