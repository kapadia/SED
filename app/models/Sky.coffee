Spine = require('spine')

class Sky extends Spine.Model
  @configure 'Sky', 'objid', 'ra', 'dec'
  
module.exports = Sky