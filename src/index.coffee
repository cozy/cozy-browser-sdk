cozysdk = exports
crud = require './crud'
binaries = require './binaries'
requests = require './requests'

###*
 Create Read Update Delete Documents
###
cozysdk.create = crud.create
cozysdk.find = crud.find
cozysdk.updateAttributes = crud.updateAttributes
cozysdk.destroy = crud.destroy

###*
 MapReduce Views Management
###
cozysdk.defineView = requests.defineView
cozysdk.queryView = requests.queryView
cozysdk.destroyByView = requests.destroyByView

###*
 Binaries Management
###
cozysdk.addBinary = binaries.addBinary
cozysdk.destroyBinary = binaries.deleteBinary
cozysdk.getBinaryURL = binaries.getBinaryURL


# retrocompatibility
cozysdk.defineRequest = requests.defineView
cozysdk.run = requests.queryView
cozysdk.destroyRequest = requests.destroyByView
cozysdk.deleteFile = (id, name, cb) -> binaries.deleteBinary null, id, name, cb
cozysdk.getFileURL = (id, name, cb) -> binaries.getBinaryURL null, id, name, cb
