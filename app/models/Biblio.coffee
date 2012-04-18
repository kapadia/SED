Spine = require('spine')

class Biblio extends Spine.Model
  @configure 'Biblio', 'objid', 'reference', 'count'

  pluralize: -> return 'Biblios'

module.exports = Biblio