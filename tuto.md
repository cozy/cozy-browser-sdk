# cozysdk-client-tuto

As a developer, do you believe it’s hard to use data from another application in your own or play with data from differing applications? Well I'm here to try to prove you can. With cozy you can do things you could'nt imagine: you'll be able to code an application without a server, and it can use data from all the apps on your cozy.

# Let's write a new contact application for cozy

Now, let's get serious and straight to the point: our goal is to build a serverless app which lists all names from the `Contact` app. It will also allow the user to create, update, and delete names.

To do so, we'll proceed in different steps. We'll start slowly by deploying a serverless "Hello World" app, and we'll finish with a full contact app using the angularjs framework. This tutorial is for everybody, from padawan to jedi, so don't be scared of it. We'll explain everything.

To see the fully working and finished version, you can go on this [github](https://github.com/lemelon/cozysdk-client-tuto) repo.

## First step : Hello World !

Here we are, doing the traditionnal "Hello World" app that can make you want to start a new career. So here's the [link](https://github.com/lemelon/cozysdk-client-tuto/tree/7b4c33ce8d1281edeb5a8017191a403ee820fde4). 

Starting from an empty repository, you will need a few files : First, the manifest `package.json` with some fields
- `name`, the name of your app (without space)
- `displayName`, the user readable name
- `description`, what the user will see when installing your app
- `cozy-type: "static"`, which tells cozy your app doesnt need a server
- `icon-path`, a path to your app icon

Also, an index.html file needs to be at the root of your repository with your 'Hello World' written in it.

Once you have these, publish your app on github and you should be able to install it from the store on your cozy. If you managed to deploy it, congratulations! If not, don't worry, we're here to help you: the most easy way to contact us is by joining our [irc channel](http://irc.lc/freenode/cozycloud).

You can also find more information about cozy deployment in the following link:

* [Package a serverless application](https://dev.cozy.io/#package-a-serverless-application-for-installation-into-your-cozy-platform)

At the end of this step, your app should be similar to [this](https://github.com/lemelon/cozysdk-client-tuto/tree/7b4c33ce8d1281edeb5a8017191a403ee820fde4). 

## Second step: Add AngularJS

### Our objectives for this step

Making an application in javascript can get complicated fast. Before we try going further, lets pick a framework and use it to display our "Hello World!" example. For this tutorial, we've chosen angularJS. 

AngularJS is a Single Page Application (SPA) framework. If you don't have an idea of what I'm talking about, I invite you to follow the official AngularJS [tutorial](https://angularjs.org/): it explains exactly what AngularJS is and why it's advantageous for the user.

AngularJS enables the user to easily create dynamic views. It's a very used SPA, so that's why it could be a beneficial learning tool.

To get started with angular, we will need to include the angularJS library in our app and declare an entry to our application, by calling `ng-app="[the name of your app]"`. We'll also need to have a main module and setup the relation between the view (home.html) and the controller (Home.Ctrl.js). If you want some styleguides for proper angular structure and coding, we recommend the[Johnpapa's angular styleguide](https://github.com/johnpapa/angular-styleguide)

### The skeleton

- `controllers/`, [Here](https://docs.angularjs.org/guide/controller) you have a guide about how controllers work
- `partials/`, All the html (view) files. Templates rendered by ng-view
- `vendor/`, The different modules (library) needed for angularjs
- `app.module.js`, Main module (route configuration, angular lib importations...)
 
If you understand the skeleton and the main logic of this code, you basically understood what angularjs is all about.

### Source code

You can find the source code for this step [here](https://github.com/lemelon/cozysdk-client-tuto/tree/973a898820625ae1e632994d94927edbc9b27e4e)!

## Third step: Get data from contacts app

Now down to some serious business: we're ready to play with different cozy applications. We decided to interact with the "Contact" app but you can also do the same for any other application. Imagine what service you can propose to your future users. But for now, let's synchronize with contacts by getting all the names of the user contacts...

### Install the contact app from the store and create or import a few of your contacts

To understand what we are doing here, you will need to have some contacts in your cozy database. If you haven't done so already, install the Cozy Contacts application from the store on your cozy and enter some contacts. You can import some contacts from google or insert new contacts manually.

#### Our objectives for this step

For this step, we'll have to get the list of all the names of the contact app. First of all, we'll need to create permissions in the 'package.json' file to be able to access the data of the `Contact` app. 

You'll also need to import two files into your project:

- [cozysdk-client.js](https://github.com/lemelon/cozysdk-client/blob/master/dist/cozysdk-client.js): this is a javascript cozy library that enables to do clean request to the data-system. You can access this [tutorial](https://github.com/lemelon/cozysdk-client/blob/master/api.md) to learn how to use it.
- [cozysdk.angular.js](https://github.com/lemelon/cozysdk-client-tuto/blob/master/interfaces/cozysdk.angular.js): this is the cozy file that enables you to connect the logic of the cozysdk-client library with angularjs. It helps developers to work with organized code in angularjs.

Both these files are optional, you could use `postMessage` to retrieve your app token and then do manual `XMLHttpRequest` calls against the [data-system api](https://docs.cozy.io/en/hack/cookbooks/data-system.html), but as the saying goes: ["do not reinvent the wheel"](https://en.wikipedia.org/wiki/Reinventing_the_wheel). So why do complicated when you can do simple?

We'll also need to add, in your Home.Ctrl.js file, a call to [defineRequest](https://github.com/lemelon/cozysdk-client/blob/master/api.md#definerequestdoctype-name-request) and [run](https://github.com/lemelon/cozysdk-client/blob/master/api.md#rundoctype-name-params-callback) it to get all Contacts.

We chain and get the results of these calls through promises. If you're not familiar with this syntax, you can read more about it in [this article](http://www.webdeveasy.com/javascript-promises-and-angularjs-q-service/). Once we have the result, we can add it to our scope and display them in `home.html` by using a `ng-repeat`. 

We can also put a filter to show how simple it is to do it in angularjs, just for the fun.

### Source code

You can find the source code for this step [here](https://github.com/lemelon/cozysdk-client-tuto/tree/f3210da9e3b5e6053aa384557dcb1e952e0da45d)!

### So what happened?

This is exactly where the magic is: two apps that have nothing to do with each other, developed by two different people that might not even know eachother, can work together and be synchronized, or, even better, rationalized. In other words, this demo proves the fact that the apps can talk to eachother. So to think a bit further, the apps can share their data to be able to give transverse services. So because our applications work in the same data space, the apps start to collaborate to deliver a more integrated user experience. They are, in a certain way, smart.

## Fourth step : Create, delete or update a contact

Ok, now we're going to have some real fun, since our framework is understood and well implemented. 

#### Our objectives for this step

The only thing we'll have to do here is to add some functions in the controller. Nothing more. The other nice thing that you'll be able to notice, is that every changes is going to refresh in the contact app instantly, even without page reloading.

The functions that we'll need are `send`, `update`, and `destroy`. These function respectively enables to call [`create`](https://github.com/lemelon/cozysdk-client/blob/master/api.md#createdoctype-attributes-callback), [`updateAttributes`](https://github.com/lemelon/cozysdk-client/blob/master/api.md#updateattributesdoctype-id-attributes) and [`destroy`](https://github.com/lemelon/cozysdk-client/blob/master/api.md#destroyid-callback) from the 'cozysdk.angular.js' file.

#### Source code

You can find the source code for this step [here](https://github.com/lemelon/cozysdk-client-tuto)!

#### What to keep in mind?

So I've added four functions to the controller file : send, update, destroy, and updateContactList. 

### Going further

I think my role is complete. You now have the technical tool to develop serverless apps with angularjs on cozy. You can also acquire more skills on angularjs by googling it and seeing the enormous amount of tutorials on it. The challenge now will be to understand and meet the needs of a random cozy user. What new service can you offer this user, in order to simplify the managing of his or her data? You now know how to synchronise data from the different applications, so you'll need to go further and imagine what you can do with this knowledge.

When your application is going to be able to change the life of all the cozy users, you can add it on [cozy-registry](https://github.com/cozy/cozy-registry) by making a pull request.
