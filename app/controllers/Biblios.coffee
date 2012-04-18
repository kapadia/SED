Spine = require('spine')

class Biblios extends Spine.Controller
  constructor: ->
    super

  render: =>
    @append require('views/Biblio')(@item)
    @

  drawBiblio: ->
    $("#biblio_#{@item.id}").append("<a href='http://adsabs.harvard.edu/abs/#{@item.reference}'>#{@item.reference}</a>")

module.exports = Biblios