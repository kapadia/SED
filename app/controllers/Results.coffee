Spine ?= require('spine')
SED   ?= require('models/SpectralEnergyDistribution')
SEDs  ?= require('controllers/SpectralEnergyDistributions')

class Results extends Spine.Controller
  elements:
    '#filters.types'  : 'typesFilter'
    '#simbad-status'  : 'simbadStatus'
    '#ned-status'     : 'nedStatus'

  events:
    'click .flot-overlay' : 'examine'
    'change .types'       : 'filterByType'
    # 'mouseenter .sed' : 'showObjectNames'
    # 'mouseenter .object-name'   : 'showObjectNames'
    # 'mouseout   #object-names'  : 'hideObjectNames'

  # @archives = ['simbad', 'sdssdr7', 'glimpse', 'iras', 'chandra', 'twomass']
  @archives = ['simbad']

  constructor: ->
    super

    @simbad = false
    @ned = false

    @nedSources = []
    @crossMatches = []

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
      @updateStatus('SIMBAD', "Requesting from SIMBAD")
      $.ajax({
        dataType: 'jsonp',
        url: @generateURL('simbad', ra, dec, radius)
        callback: 'givemeseds',
        success: (data) =>
          # Parse SIMBAD VOTable
          results = {}
          table = data["VOTABLE"]["RESOURCE"]["TABLE"]["DATA"]["TABLEDATA"]["TR"]

          for row in table
            r = row["TD"]
            results[r[0]] = [] unless results.hasOwnProperty(r[0])
            results[r.shift()].push(r)

          for object, values of results
            sed = {}
            sed['origin'] = 'SIMBAD'
            sed['bibCodes'] = []
            sed['fluxDensities'] = {}
            sed['names'] = []
            values.map (value) ->
              sed['objid'] = value[2] unless sed.hasOwnProperty('objid')
              sed['ra'] = value[0] unless sed.hasOwnProperty('ra')
              sed['dec'] = value[1] unless sed.hasOwnProperty('dec')
              sed['bibCodes'].push(value[3]) unless value[3] in sed['bibCodes']
              sed['bibCodes'].push(value[10]) unless value[10] in sed['bibCodes']
              sed['fluxDensities'][value[4]] = value[5] unless sed['fluxDensities'].hasOwnProperty(value[4])
              sed['names'].push(value[8]) unless value[8] in sed['names']
              sed['type'] = value[9] unless sed.hasOwnProperty('type')

            @initializeSedModel(sed)

          @updateStatus('SIMBAD', "SIMBAD Request Complete")
          @simbadStatus.siblings("img").remove()

          @simbad = true
          @crossMatch()
        error: (e) =>
          console.log 'oh well ...', e
      })

    @updateStatus('NED', "Requesting from NED")
    $.ajax({
      dataType: 'jsonp',
      url: @generateURL('ned', ra, dec, radius),
      callback: 'givemeobjectnames',
      success: (data) =>
        # Parse NED VOTable
        table = data["VOTABLE"]["RESOURCE"]["TABLE"]

        for item in table
          object = {}
          object['names'] = []
          object['types'] = []

          item = item["DATA"]["TABLEDATA"]["TR"]
          if item.constructor.name is 'Array'
            for obj in item
              obj = obj["TD"]
              object['names'].push(obj[0])
              object['types'].push(obj[1])
          else
            item = item["TD"]
            object['names'].push(item[0])
            object['types'].push(item[1])
          @nedSources.push(object)
          @updateStatus('NED', "NED Request Complete")

        @ned = true
        @crossMatch()
      error: (e) =>
        console.log 'oh well ...', e
    })

  generateURL: (survey, ra, dec, radius = 10, objectName) ->
    # return "http://apps.galaxyzoo.org/getseds.json?survey=#{survey}&ra=#{ra}&dec=#{dec}&radius=#{radius}"
    # return "http://www.milkywayproject.org/gator.json?radius=#{radius}&ra=#{ra}&dec=#{dec}"
    if survey is 'ned'
      if ra? and dec?
        url = "http://0.0.0.0:3000/ned.json?&ra=#{ra}&dec=#{dec}&radius=#{radius}"
      else
        url = "http://0.0.0.0:3000/ned.json?name=#{objectName}"
    else if survey is 'simbad'
      if ra? and dec?
        url = "http://0.0.0.0:3000/simbad.json?&ra=#{ra}&dec=#{dec}&radius=#{radius}"
      else
        url = "http://0.0.0.0:3000/simbad.json?&name=#{objectName}"
    console.log url
    return url

  initializeSedModel: (sed) ->
    model = new SED sed
    model.save()
    unless sed['type'] in @objectTypes
      @objectTypes.push sed['type']
      $("#filters .types").append("<option value='#{sed.type}'>#{model.getObjectType()}</option>")

  addSedController: (model) ->
    view = new SEDs {item: model, el: $("#results")}
    view.render()

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

  crossMatch: =>
    return unless (@ned and @simbad)

    for source in @nedSources
      for name in source['names']
        if SED.lookup.hasOwnProperty(name)
          sed = SED.find(SED.lookup[name])
          @crossMatches.push(sed)

    index = 0
    
    for source in @nedSources
      do (source) =>
        name = source['names'][0]

        $.ajax({
          dataType: 'jsonp',
          url: @generateURL('ned', undefined, undefined, undefined, name),
          callback: 'givemenedseds',
          success: (data) =>
            index += 1
            @updateStatus('NED', "Waiting for #{@nedSources.length - index} objects from NED")
            if @nedSources.length - index is 0
              @nedStatus.siblings("img").remove() 
              @updateStatus('NED', "NED Request Complete")
            
            sed = {}
            table = data["VOTABLE"]["RESOURCE"]["TABLE"]["DATA"]["TABLEDATA"]["TR"]
            if table.constructor.name is 'Object'
              table = table["TD"]
              
              freq = parseFloat(table[5])
              c = 2.998E8
              lambda = (c / freq * 1E9).toFixed(2)
              
              sed['origin'] = 'NED'
              sed['objid'] = source['names'].shift()
              sed['ra'] = table[13]
              sed['dec'] = table[13]
              sed['bibCodes'] = [table[9]]
              sed['fluxDensities'] = {}
              sed['fluxDensities']["#{lambda}"] = table[6]
              sed['names'] = source['names'] unless source['names'].length is 0
              sed['type'] = source['types'][0]
            else
              sed = {}
              sed['origin'] = 'NED'
              sed['objid'] = source['names'].shift()
              sed['ra'] = table[0]["TD"][13]
              sed['dec'] = table[0]["TD"][13]
              sed['bibCodes'] = []
              sed['fluxDensities'] = {}
              sed['names'] = source['names']
              sed['type'] = source['types'][0]
              for row in table
                row = row["TD"]
                freq = parseFloat(row[5])
                c = 2.998E8
                lambda = (c / freq * 1E9).toFixed(2)
                sed['fluxDensities']["#{lambda}"] = row[6]
            @initializeSedModel(sed)
        })

  examine: (e) =>
    cid = $(e.currentTarget).parent().attr("id")
    item = SED.find(cid)
    @navigate('/results', encodeURIComponent(item.objid), {id: cid})

  updateStatus: (archive, msg) =>
    if archive is 'SIMBAD'
      @simbadStatus.html(msg)
    else
      @nedStatus.html(msg)

module.exports = Results