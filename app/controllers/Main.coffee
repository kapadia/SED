
class Main extends Spine.Controller
  elements:
    '#ra-input'     : 'ra'
    '#dec-input'    : 'dec'
    '#radius-input' : 'radius'
    '#results'      : 'results'

  events:
    'click #submit' : 'submit'
    'click .result' : 'examine'

  constructor: ->
    super

    @html require('views/main')()

    # # TEMP: default values
    # @ra.val(18.39509)
    # @dec.val(-13.25730)
    # @radius.val(50)

  submit: (e) ->
    e.preventDefault()
    @navigate '/results', @ra.val(), @dec.val(), @radius.val()
    

module.exports = Main