
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

  requestFITS: ->
    url = "http"

  examine: ->
    @plotView = new SEDs {item: @item, el: $("#examine")}
    @plotView.render(false)
    # @sky()

module.exports = Examine