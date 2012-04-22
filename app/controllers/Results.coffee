Spine ?= require('spine')
SED   ?= require('models/SpectralEnergyDistribution')
SEDs  ?= require('controllers/SpectralEnergyDistributions')

class Results extends Spine.Controller
  elements:
    '#filters.types' : 'typesFilter'

  events:
    'click .sed'    : 'examine'
    'change .types' : 'filterByType'
    # 'mouseenter .object-name'   : 'showObjectNames'
    # 'mouseout   #object-names'  : 'hideObjectNames'

  constructor: ->
    super
    SED.bind "create", @addSedController

    @objectTypes = []
    @filterType = null

    @append require('views/results')()
    @active (params) ->
      @change()
      @getData params.ra, params.dec, params.radius

  change: () ->
    @render()

  render: ->
    @html require('views/results')()
    @

  getData: (ra, dec, radius) ->
    if SED.count() > 0
      @addSedController(sed) for sed in SED.all()
      @initializeFilter()
    else
      @initializeSedModel(sed) for sed in data
      @initializeFilter()
      # $.ajax({
      #   dataType: 'jsonp',
      #   url: @generateURL(ra, dec, radius),
      #   callback: 'givemeseds',
      #   success: (data) =>
      #     @initializeSedModel(sed) for sed in data
      #     @initializeFilter()
      #   error: (e) =>
      #     console.log 'oh well ...'
      # })

  generateURL: (ra, dec, radius = 30) ->
    return "http://www.milkywayproject.org/gator.json?radius=#{radius}&ra=#{ra}&dec=#{dec}"

  initializeSedModel: (sed) ->
    @objectTypes.push sed['type'] unless sed['type'] in @objectTypes

    params = {}
    params['objid']     = sed['object_name']
    params['ra']        = sed['ra']
    params['dec']       = sed['dec']
    params['bibcodes']  = sed['bibcodes']
    params['ra']        = sed['ra']
    params['names']     = sed['all_names']
    params['type']      = sed['type']
    delete sed['object_name']
    delete sed['ra']
    delete sed['dec']
    delete sed['bibcodes']
    delete sed['ra']
    delete sed['all_names']
    delete sed['type']
    params['fluxDensities'] = sed
    model = new SED params
    model.save()

  addSedController: (model) ->
    view = new SEDs {item: model, el: $("#results")}
    view.render()

  initializeFilter: ->
    $("#filters").append( require('views/types')({types: @objectTypes}) )
    if @filterType
      $("#types-filter option[value='#{@filterType}']").attr('selected', 'selected')
      $("#types-filter").trigger('change')

  filterByType: (e) ->
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
    @navigate('/results', cid)

  # TODO: Build good UI to show cross reference of object names
  showObjectNames: (e) ->
    cid = $(e.currentTarget).parent().attr("data-cid")
    names = SED.find(cid).names
    position = $(e.currentTarget).position()
    if names.length > 1
      $("#object-names").remove()
      html = "<div id='object-names'>"
      html += "<div class='object-name'>#{name}</div>" for name in names
      html += "</div>"
      $(html).css({
        position: 'fixed',
        display: 'none',
        left: position[0] - 240,
        top: position[1],
        border: '1px solid #FDD',
        padding: '2px',
        'background-color': '#FEE',
        opacity: 0.80
      }).appendTo("#results").show()

  hideObjectNames: (e) -> $("#object-names").remove()

module.exports = Results