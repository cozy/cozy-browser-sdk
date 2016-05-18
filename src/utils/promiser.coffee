module.exports = (fn) ->
    promiseSupport = 'undefined' isnt typeof Promise
    return fn unless promiseSupport

    return ->
        # if a callback is provided, just use it
        if 'function' is typeof arguments[arguments.length-1]
            return fn.apply this, arguments

        args = (arg for arg in arguments)

        return new Promise (resolve, reject) =>
            # add callback
            args.push (err, result) ->
                if err then reject(err) else resolve(result)

            # call the original fn
            fn.apply this, args
