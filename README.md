# cozy-browser-sdk

[This document](https://cozy.github.io/cozy-browser-sdk/index.html) covers the API documentation of the SDK for Cozy apps without a
server.

Disclaimer: This is not a tutorial to write Cozy application, if you want to understand how to write apps without a server with Cozy, you can read this [tutorial](https://dev.cozy.io/clientsideapp.html).

## What is it for?

`cozy-browser-sdk` is a javascript library made by Cozy. It enables client-side  applications to easily make requests to the data-system. The Data-system is the data
storage API of the Cozy.

## How to use it?

You just have to copy a single file ([dist/cozysdk-client.js](https://github.com/cozy/cozy-browser-sdk/tree/master/dist)) to your app repository. You can then `require` it by using any build tool or include it in your html page through a `<script>` tag.

We recommend you to follow this [tutorial](https://dev.cozy.io/clientsideapp.html) to setup the Cozy SDK tutorial properly.

You can also use `npm` (`npm install cozysdk-client`) and then `require` it from your JS file:
```js
var cozySDK = require('cozysdk-client');
```

## What can it do?

- Create, Read, Update, Delete documents ([tuto](http://cozy.github.io/cozy-browser-sdk/tutorial-doctype.html))
  - [cozysdk.create](http://cozy.github.io/cozy-browser-sdk/module-crud.html#.create)
  - [cozysdk.find](http://cozy.github.io/cozy-browser-sdk/module-crud.html#.find)
  - [cozysdk.updateAttributes](http://cozy.github.io/cozy-browser-sdk/module-crud.html#.updateAttributes)
  - [cozysdk.destroy](http://cozy.github.io/cozy-browser-sdk/module-crud.html#.destroy)

- Define and use couchdb views ([tuto](http://cozy.github.io/cozy-browser-sdk/tutorial-mapreduce.html))
  - [cozysdk.defineView](http://cozy.github.io/cozy-browser-sdk/module-mapreduce.html#.defineView)
  - [cozysdk.queryView](http://cozy.github.io/cozy-browser-sdk/module-mapreduce.html#.queryView)
  - [cozysdk.destroyByView](http://cozy.github.io/cozy-browser-sdk/module-mapreduce.html#.destroyByView)

- Read and Destroy binaries attached to Cozy documents
  - [cozysdk.getBinaryURL](http://cozy.github.io/cozy-browser-sdk/module-binaries.html#.getBinaryURL)
  - [cozysdk.removeBinary](http://cozy.github.io/cozy-browser-sdk/module-binaries.html#.removeBinary)


## License

Cozy Browser SDK is developed by Cozy Cloud and distributed under the MIT license.

## What is Cozy?

![Cozy Logo](https://raw.github.com/cozy/cozy-setup/gh-pages/assets/images/happycloud.png)

[Cozy](https://cozy.io) is a platform that brings all your web services in the
same private space.  With it, your web apps and your devices can share data
easily, providing you
with a new experience. You can install Cozy on your own hardware where no one
profiles you.

## Community

You can reach the Cozy Community by:

* Chatting with us on IRC #cozycloud on irc.freenode.net
* Posting on our [Forum](https://forum.cozy.io/)
* Posting issues on the [Github repos](https://github.com/cozy/)
* Mentioning us on [Twitter](https://twitter.com/mycozycloud)
