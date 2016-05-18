client = require './utils/client'
promiser = require './utils/promiser'

###*
 <h2>cozysdk functions to manipulate document binaries</h2>

 Binaries can be attached to a document.
 Attaching binaries is not supported in cozysdk for browser, if your
 application needs to create document with binaries, add +1 to the
 <a href="https://github.com/cozy/cozy-browser-sdk/issues/14">Github ticket</a>
 related to this feature.

 @module binaries
###

###*
Delete binary linked to the document matching ID. Several binaries
can be attached to a document, so a name is required to know which file
should be deleted.

@function

@arg {string} docType - The docType of the document to remove a binary from.
@arg {string} id - The id of the document to remove a binary from.
@arg {string} name - The name of the binary to destroy.
@arg {callback} [callback] - A node.js style callback

@example <caption>callback</caption>
cozysdk.removeBinary('Note', '524noteid452', 'image.jpg', function(err){
    // image.jpg has been removed from note 524noteid452
});
@example <caption>promise</caption>
cozysdk.removeBinary('Note', '524noteid452', 'image.jpg')
###
module.exports.removeBinary = promiser (docType, id, name, callback) ->
    path = "/data/" + id + "/binaries/" + name
    client.del path, {}, (error, response, body) ->
        if error
            callback error
        else if response.status isnt 204
            callback new Error "#{response.status} -- Server error occured."
        else
            callback null, body


###*
Build file url for file linked to the document matching ID. Several binaries
can be attached to a document, so a name is required to know which file
should be retrieved.
It's useful when you want to retrieve a file from the file application or a
picture from the photo app.

@function

@arg {string} docType - The docType of the document to retrieve a binary from.
@arg {string} id - The id of the document to retrieve a binary from.
@arg {string} name - The name of the binary to retrieve.
@arg {callback} [callback] - A node.js style callback

@example <caption>callback</caption>
cozysdk.getBinaryURL('Note', '524noteid452', 'image.jpg', function(err, url){
    img.src = url
    // url = 'https://your.cozy.cloud/ds-api/524noteid542/binaries/...
    //                                ...image.jpg?=token=zdkgzerozernxwxoicvh'
});
@example <caption>promise</caption>
cozysdk.getBinaryURL('Note', '524noteid452', 'image.jpg')
###
module.exports.getBinaryURL = promiser (docType, id, name, callback) ->
    path = "/ds-api/data/#{id}/binaries/#{name}"
    host = window.location.host
    client.getToken (err, auth) ->
        return callback err if err

        auth = "Basic " + btoa "#{auth.appName}:#{auth.token}"
        url = "#{window.location.protocol}//#{host}#{path}"
        url += "?authorization=#{auth}"
        callback null, encodeURI(url)
