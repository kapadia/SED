Spine ?= require('spine')
SED   ?= require('models/SpectralEnergyDistribution')
SEDs  ?= require('controllers/SpectralEnergyDistributions')

class Results extends Spine.Controller
  elements:
    '#filters.types' : 'typesFilter'

  events:
    'click .sed'      : 'examine'
    'change .types'   : 'filterByType'
    # 'mouseenter .sed' : 'showObjectNames'
    # 'mouseenter .object-name'   : 'showObjectNames'
    # 'mouseout   #object-names'  : 'hideObjectNames'

  # @archives = ['simbad', 'sdssdr7', 'glimpse', 'iras', 'chandra', 'twomass']
  @archives = ['xmm']

  constructor: ->
    super
    SED.bind "create", @addSedController

    @objectTypes = []
    @filterType = null

    @append require('views/results')()
    @active (params) ->
      @change()
      @getData params.ra, params.dec, params.radius

  change: () -> @render()

  render: ->
    @html require('views/results')()
    @

  getData: (ra, dec, radius) ->
    if SED.count() > 0
      @addSedController(sed) for sed in SED.all()
    else
      for archive in Results.archives
        console.log @generateURL(archive, ra, dec, radius)
        $.ajax({
          dataType: 'jsonp',
          url: @generateURL(archive, ra, dec, radius)
          callback: 'givemeseds',
          success: (data) =>
            return if data[0]['message']
            @initializeSedModel(sed) for sed in data
          error: (e) =>
            console.log 'oh well ...', e
        })

  generateURL: (survey, ra, dec, radius = 30) ->
    # return "http://apps.galaxyzoo.org/getseds.json?survey=#{survey}&ra=#{ra}&dec=#{dec}&radius=#{radius}"
    return "http://0.0.0.0:3000/getseds.json?survey=#{survey}&ra=#{ra}&dec=#{dec}&radius=#{radius}"
    # return "http://www.milkywayproject.org/gator.json?radius=#{radius}&ra=#{ra}&dec=#{dec}"

  initializeSedModel: (sed) ->
    unless sed['type'] in @objectTypes
      @objectTypes.push sed['type']
      $("#filters .types").append("<option value='#{sed.type}'>#{sed.type}</option>")

    params = {}
    params['objid']     = sed['object_name']
    params['ra']        = sed['ra']
    params['dec']       = sed['dec']
    params['bibcodes']  = sed['bibcodes']
    params['ra']        = sed['ra']
    params['names']     = sed['all_names']
    params['type']      = sed['type']
    params['misc']      = sed['misc']
    delete sed['object_name']
    delete sed['ra']
    delete sed['dec']
    delete sed['bibcodes']
    delete sed['ra']
    delete sed['all_names']
    delete sed['type']
    delete sed['misc']
    params['fluxDensities'] = sed
    model = new SED params
    model.save()

  addSedController: (model) ->
    view = new SEDs {item: model, el: $("#results")}
    view.render()

  filterByType: (e) ->
    console.log SED.all()
    @filterType = e.target.value
    for sed in SED.all()
      if @filterType is "all"
        $("##{sed.cid}").parent().show()
      else if sed.type is @filterType
        $("##{sed.cid}").parent().show()
      else
        $("##{sed.cid}").parent().hide()

  back: => Spine.navigate('/') if @.active?

  examine: (e) =>
    cid = $(e.currentTarget).children('.plot').first().attr("id")
    item = SED.find(cid)
    @navigate('/results', encodeURIComponent(item.objid), {id: cid})

  # TODO: Build good UI to show cross reference of object names
  showObjectNames: (e) ->
    cid = $(e.currentTarget).attr("data-cid")
    # cid = $(e.currentTarget).parent().attr("data-cid")
    sed = SED.find(cid)
    names = SED.find(cid).names
    position = $(e.currentTarget).position()
    # if names.length > 1
    #   $("#object-names").remove()
    #   html = "<div id='object-names'>"
    #   html += "<div class='object-name'>#{name}</div>" for name in names
    #   html += "</div>"
    #   $(html).css({
    #     position: 'fixed',
    #     display: 'none',
    #     left: position[0] - 240,
    #     top: position[1],
    #     border: '1px solid #FDD',
    #     padding: '2px',
    #     'background-color': '#FEE',
    #     opacity: 0.80
    #   }).appendTo("#results").show()

  hideObjectNames: (e) -> $("#object-names").remove()

module.exports = Results