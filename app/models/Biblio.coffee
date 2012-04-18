Spine = require('spine')

class Biblio extends Spine.Model
  @configure 'Biblio', 'objid', 'reference'
  
module.exports = Biblio