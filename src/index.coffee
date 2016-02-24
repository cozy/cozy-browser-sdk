client = require './utils/client'


# Set of helpers to deal easily with the Data System API from the browser.


define = (docType, name, request, callback) ->
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


# Creates a new document for given doc type with fields given in the attributes
# object.
module.exports.create = (docType, attributes, callback) ->
    path = "data/"
    attributes.docType = docType

    if attributes.id?
        return callback new Error 'cant create an object with a set id'

    client.post path, attributes, (error, response, body) ->
        if error
            callback "#{response.status} -- #{body.id} -- #{error}"
        else
            callback null, JSON.parse body


# Retrieve document matching given doc type and given ID.
module.exports.find = (docType, id, callback) ->
    client.get "data/#{id}/", null, (error, response, body) ->
        if error
            callback error
        else if response.status is 404
            callback new Error \
                "#{response.status} -- #{body.id} -- Error in finding object"
        else
            callback null, body


# Update attributes of the document that matches given doc type and given ID.
module.exports.updateAttributes = (docType, id, attributes, callback) ->
    attributes.docType = docType
    client.put "data/merge/#{id}/", attributes, (error, response, body) ->
        if error
            callback error
        else if response.status is 404
            callback new Error "Document #{id} not found"
        else if response.status isnt 200
            callback new Error \
                "#{response.status} -- #{body.id} -- Server error occured."
        else
            callback null, JSON.parse body


# Destryo the document that matches given doc type and given ID.
module.exports.destroy = (docType, id, callback) ->
    client.del "data/#{id}/", null, (error, response, body) ->
        if error
            callback error
        else if response.status is 404
            callback new Error "Document #{id} not found"
        else if response.status isnt 204
            callback new Error \
                "#{response.status} -- #{id} -- Server error occured."
        else
            callback null


# Define a map/reduce request for a given doc type.
module.exports.defineRequest = (docType, name, request, callback) ->
    request = map: request if typeof(request) in ['function', 'string']
    define docType, name, request, callback


# Run request matching given name for given doc type. It accepts CouchDB like
# params.
module.exports.run = (docType, name, params, callback) ->
    [params, callback] = [{}, params] if typeof(params) is 'function'

    path = "request/#{docType}/#{name.toLowerCase()}/"
    client.post path, params, (error, response, body) ->

        if error
            callback error

        else if response.status isnt 200
            callback new Error "#{response.status} -- Server error occured."

        else
            callback null, body


# Destroy every documents matching the results of request matching given name
# and given doc type.
module.exports.requestDestroy = (docType, name, params, callback) ->

    [params, callback] = [{}, params] if typeof(params) is 'function'

    path = "request/#{docType}/#{name.toLowerCase()}/destroy/"
    client.put path, params, (error, response, body) ->

        if error
            return error

        else if response.status isnt 204
            msgStatus = "expected: #{expectedCode}, got: #{response.status}"
            err = new Error "#{msgStatus} -- #{body.error} -- #{body.reason}"
            err.status = response.status
            callback err

        else
            callback null, body

