client = require './utils/client'
promiser = require './utils/promiser'


###*
 A node.js style callback.
 @callback callback
 @param {Error} error
 @param {*} [result]
###

###*
 <h2>cozysdk Map Reduce functions</h2>

 Queries in cozy are made using couchdb map/reduce view system.
 Read more in the [tutorial]{@tutorial mapreduce}.

 @module mapreduce
 @tutorial mapreduce
###


###*
Define a map/reduce request for a given doc type.

@function

@arg {string} docType - The doctype you want to create a view on.
@arg {string} name - The name of the view to create.
@arg {string|Function|Object} request - The request to define. it can either be
        a function, a string (function.toString()) or an object with
        map & reduce attributes.
@arg {Function} request._ - A map function, taking doc as parameter.
@arg {String} request._ - The same function as a string (.toString)
@arg {Object} request._ - An object with both map & reduce functions.
@arg {callback} [callback] - A node.js style callback

@warning Your app needs the permission on the doctype passed as argument.

@example <caption>callback</caption>
byTitle = function(doc) { emit(doc.title); }
cozysdk.defineMapReduceView('Note', 'all', byTitle, function(err){
    // view has been created
});
@example <caption>promise</caption>
byTitle = function(doc) { emit(doc.title); }
cozysdk.defineMapReduceView('Note', 'all', byTitle)
###
module.exports.defineMapReduceView = promiser (docType, name, request, \
                                                                  callback) ->
    request = map: request if typeof(request) in ['function', 'string']
    {map, reduce} = request

    # transforms all functions into string
    # function named(a, b){...} --> function (a, b){...}
    # function (a, b){...} --> function (a, b){...}
    if reduce? and typeof reduce is 'function'
        reduce = reduce.toString()
        reduceArgsAndBody = reduce.slice reduce.indexOf '('
        reduce = "function #{reduceArgsAndBody}"

    view =
        reduce: reduce
        map: """
            function (doc) {
                if (doc.docType.toLowerCase() === "#{docType.toLowerCase()}") {
                    filter = #{map.toString()};
                    filter(doc);
                }
            }
        """

    path = "request/#{docType}/#{name.toLowerCase()}/"
    client.put path, view, (error, response, body) ->
        if error
            return error
        else if response.status isnt 200
            msgStatus = "expected: 200, got: #{response.status}"
            err = new Error "#{msgStatus} -- #{body.error} -- #{body.reason}"
            err.status = response.status
            callback err
        else
            callback null, body


###*
Query a map/reduce view.
It accepts CouchDB like params.

@function

@arg {string} docType - The doctype you want to query a view on.
@arg {string} name - The name of the view to query.
@arg {Object} params - The query parameters.
@param {mixed} [params.key] - get all entries with this key
@param {mixed[]} [params.keys] - get all entries with one of these keys
@param {mixed} [params.startkey] - get all entries with key greater than this
        value
@param {String} [params.startkey_docid] - document id to start with (to allow
        pagination for duplicate startkeys)
@param {mixed} [params.endkey] - get all entries with key lesser than this value
@param {String} [params.endkey_docid] - last document id to include in the
        output (to allow pagination for duplicate endkeys)
@param {Number} [params.limit=Infinity] - Limit the number of documents in
        the output
@param {Number} [params.skip=0] - skip n number of documents
@param {Boolean} [params.descending=false] - change the direction of search
@param {Boolean} [params.group=false] - The group option controls whether
        the reduce function reduces to a set of distinct keys or to a single
        result row.
@param {Number} [params.group_level] - see below
@param {Boolean} [params.reduce=true] - use the reduce function of the view.
        It defaults to true, if a reduce function is defined and to false
        otherwise.
@param {Boolean} [params.include_docs=false] - automatically fetch and include
        the document which emitted each view entry
@param {Boolean} [params.inclusive_end=true] - Controls whether the endkey is
        included in the result. It defaults to true.
@param {Boolean} [params.update_seq=] - Response includes an update_seq value
        indicating which sequence id of the database the view reflects
@arg {callback} [callback] - A node.js style callback

@example <caption>callback</caption>
params = {startkey 'A', endkey: 'B'}
cozysdk.queryView('Note', 'byTitle', params, function(err){
    // get all notes with a title starting by A
});
@example <caption>promise</caption>
params = {startkey 'A', endkey: 'B'}
cozysdk.queryView('Note', 'byTitle', params)
###
module.exports.queryView = (docType, name, params, callback) ->
    [params, callback] = [{}, params] if typeof(params) is 'function'

    path = "request/#{docType}/#{name.toLowerCase()}/"
    client.post path, params, (error, response, body) ->

        if error
            callback error

        else if response.status isnt 200
            callback new Error "#{response.status} -- Server error occured."

        else
            callback null, JSON.parse body

###*
Destroy every documents that would have been returned by a call to
[queryView]{@link module:mapreduce.queryView} with the same parameters.
Destroy all DocumentsQuery a map/reduce view.
It accepts CouchDB like params.

@function
@arg {string} docType - The doctype you want to query a view on.
@arg {string} name - The name of the view to query.
@arg {Object} params - The same query parameters than
        [queryView]{@link module:mapreduce.queryView}.
@arg {Object} params.limit - <strong>Warning</strong> The limit param is
        ignored for deletion.
@arg {callback} [callback] - A node.js style callback

@example <caption>callback</caption>
params = {startkey 'A', endkey: 'B'}
cozysdk.destroyByView('Note', 'byTitle', params, function(err){
    // destroy all notes with a title starting by A
});
@example <caption>promise</caption>
params = {startkey 'A', endkey: 'B'}
cozysdk.destroyByView('Note', 'byTitle', params)
###
module.exports.destroyByView = (docType, name, params, callback) ->

    [params, callback] = [{}, params] if typeof(params) is 'function'

    path = "request/#{docType}/#{name.toLowerCase()}/destroy/"
    client.put path, params, (error, response, body) ->

        if error
            return error

        else if response.status isnt 204
            msgStatus = "expected: 204, got: #{response.status}"
            err = new Error "#{msgStatus} -- #{body.error} -- #{body.reason}"
            err.status = response.status
            callback err

        else
            callback null, body
