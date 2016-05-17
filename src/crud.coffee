client = require './utils/client'
promiser = require './utils/promiser'

###*
 <h2>Cozysdk CRUD functions</h2>

<ul>
<li>Create a document [cozysdk.create]{@link module:crud.create }</li>
<li>Find a document [cozysdk.find]{@link module:crud.find }</li>
<li>Update a document
    [cozysdk.updateAttributes]{@link module:crud.updateAttributes}</li>
<li>Delete a document [cozysdk.destroy]{@link module:crud.destroy }</li>
</ul>

 @module crud

 @tutorial doctype

###

###*
Creates a new document for given doc type with fields given
in the attributes object.

@function
@arg {string} docType - The doctype you want to create.
@arg {Object} attributes - The attributes your document should have.
@arg {callback} [callback] - A node.js style callback

@example <caption>callback</caption>
var attributes = {title:"hello", content:"world"}
cozysdk.create('Note', attributes, function(err, obj){
    console.log(obj.id)
});
@example <caption>promise</caption>
var attributes = {title:"hello", content:"world"}
cozysdk.create('Note', attributes)
    .then(function(obj){ console.log(obj.id) } );
###
module.exports.create = promiser (docType, attributes, callback) ->
    attributes.docType = docType

    if attributes.id?
        return callback new Error 'cant create an object with a set id'

    client.post "data/", attributes, (error, response, body) ->
        if error
            callback new Error "#{response.status} -- #{body.id} -- #{error}"
        else
            callback null, JSON.parse body


###*
Retrieve a document by its ID.

@function
@arg {string} docType - The doctype you want to create.
@arg {string} id - The id of the document you want to retrieve.
@arg {callback} [callback] - A node.js style callback

@example <caption>callback</caption>
cozysdk.find('Note', '732732832832', function(err, note){ note.title });
@example <caption>promise</caption>
cozysdk.find('Note', '732732832832').then( function(note){ note.title } );
###
module.exports.find = promiser (docType, id, callback) ->
    client.get "data/#{id}/", null, (error, response, body) ->
        if error
            callback error
        else if response.status is 404
            callback new Error \
                "#{response.status} -- #{body.id} -- Error in finding object"
        else
            callback null, JSON.parse body


###*
Update attributes of the document that matches given doc type and given ID..

@function
@arg {string} docType - The doctype of the document you want to change.
@arg {string} id - The id of the document you want to change.
@arg {Object} attrs - The changes you want to make.
@arg {callback} [callback] - A node.js style callback

@example <caption>callback</caption>
cozysdk.find('Note', '732732832832', function(err, note){
    console.log(note) // {title: "hello", content: "world"}
    var changes = {title: "Hola"};
    cozysdk.updateAttributes('Note', '732732832832', changes, function(){
        // note now is {title: "Hola", content: "world"}
    });
});
@example <caption>promise</caption>
cozysdk.find('Note', '732732832832')
.then( function(note){
    var changes = {title: "Hola"};
    return cozysdk.updateAttributes('Note', '732732832832', changes)
} )
.then( function(){
    // note now is {title: "Hola", content: "world"}
})
###
module.exports.updateAttributes = promiser (docType, id, attrs, callback) ->
    attrs.docType = docType
    client.put "data/merge/#{id}/", attrs, (error, response, body) ->
        if error
            callback error
        else if response.status is 404
            callback new Error "Document #{id} not found"
        else if response.status isnt 200
            callback new Error \
                "#{response.status} -- #{body.id} -- Server error occured."
        else
            callback null, JSON.parse body


###*
Delete a document by its ID.

@function
@arg {string} docType - The doctype you want to destroy.
@arg {string} id - The id of the document you want to destroy.
@arg {callback} [callback] - A node.js style callback

@example <caption>callback</caption>
cozysdk.destroy('Note', '732732832832' function(err){
    // note has been destroyed
});
@example <caption>promise</caption>
cozysdk.destroy('Note', '732732832832')
.then( function(note){
    // note has been destroyed
})
###
module.exports.destroy = promiser (docType, id, callback) ->
    client.del "data/#{id}/", null, (error, response) ->
        if error
            callback error
        else if response.status is 404
            callback new Error "Document #{id} not found"
        else if response.status isnt 204
            callback new Error \
                "#{response.status} -- #{id} -- Server error occured."
        else
            callback null
