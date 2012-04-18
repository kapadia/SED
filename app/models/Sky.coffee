Spine = require('spine')

class Sky extends Spine.Model
  @configure 'Sky', 'objid', 'ra', 'dec'
  
  pluralize: -> return 'Skies'
  
module.exports = Sky