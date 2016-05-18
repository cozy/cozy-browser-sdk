# cozy-browser-sdk

SDK for Cozy apps without a server.

If you want to understand how to write apps without a server with Cozy, you can also follow this [tutorial](https://dev.cozy.io/clientsideapp.html).

## What is it for?

`cozy-browser-sdk` is a javascript library made by Cozy. It enables clien-side  applications to make requests to the data-system easily.

## How do I use it ?

Just copy the file `dist/cozysdk-client.js` file to your app repository. You can then `require` it using any build tool or include it in your html page through a `<script>` tag.

You should probably follow this [tutorial](https://dev.cozy.io/clientsideapp.html).

## What can it do ?

- Create, Read, Update, Delete documents ([tuto](http://cozy.github.io/cozy-browser-sdk/tutorial-doctype.html))
  - [cozysdk.create](http://cozy.github.io/cozy-browser-sdk/module-crud.html#.create)
  - [cozysdk.find](http://cozy.github.io/cozy-browser-sdk/module-crud.html#.find)
  - [cozysdk.updateAttributes](http://cozy.github.io/cozy-browser-sdk/module-crud.html#.updateAttributes)
  - [cozysdk.destroy](http://cozy.github.io/cozy-browser-sdk/module-crud.html#.destroy)

- Define and use couchdb views ([tuto](http://cozy.github.io/cozy-browser-sdk/tutorial-mapreduce.html))
  - [cozysdk.defineMapReduceView](http://cozy.github.io/cozy-browser-sdk/module-mapreduce.html#.defineMapReduceView)
  - [cozysdk.queryView](http://cozy.github.io/cozy-browser-sdk/module-mapreduce.html#.queryView)
  - [cozysdk.destroyByView](http://cozy.github.io/cozy-browser-sdk/module-mapreduce.html#.destroyByView)

- Read and Destroy binaries attachment to documents
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
