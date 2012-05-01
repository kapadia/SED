Sky   = require('models/Sky')
Skies = require('controllers/Skies')
SED   ?= require('models/SpectralEnergyDistribution')

class Examine extends Spine.Controller

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    if id?
      @item = SED.find(id)
    else
      # data = [{"object_name":"V* IM Her","type":"EB*Algol","ra":255.54483749999997,"dec":32.198072222222216,"J":0.025183522208089882,"H":0.020702656469160346,"K":0.013880071059123695,"R":0.016515126201576396,"B":0.009759096200790721,"all_names":["V* IM Her"],"bibcodes":["2003yCat.2246....0C","2003AstL...29..468S"]}]
      @initializeSedModel(data[0])
      $.ajax({
        dataType: 'jsonp',
        url: @generateURL(ra, dec, radius),
        callback: 'givemesed',
        success: (data) =>
          # throw 'blah'
          @initializeSedModel(data[0])
        error: (e) =>
          @navigate '/'
          $("#message").html("Sorry, the query cannot be completed.")
          
      })
    @render()

  render: =>
    @html require('views/examine')(@item)
    @examine()
    @

  examine: ->
    @plot()
    # @sky()

  plot: ->
    @plotView = new SEDs {item: @item, el: $("#examine .sed")}
    @plotView.render(false)

  sky: ->
    model = new Sky {'objid': @item.objid, 'ra': @item.ra, 'dec': @item.dec}
    @skyView = new Skies {item: model, el: $("#examine .sky")}
    @skyView.render()

  initializeSedModel: (sed) ->
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
    @item = new SED params
    @item.save()

module.exports = Examine