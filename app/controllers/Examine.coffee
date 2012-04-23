Sky   = require('models/Sky')
Skies = require('controllers/Skies')

class Examine extends Spine.Controller

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = SED.find(id)
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

module.exports = Examine