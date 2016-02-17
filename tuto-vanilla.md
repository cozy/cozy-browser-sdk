# cozysdk-client-tuto-vanilla

As a developer, do you believe it’s hard to play with data from differing applications? Well I'm here to try to prove you can and even more: you'll be able to code an application without a server, and this application will be able to use data from all the apps on your Cozy.

# Let's write a new contact application for Cozy

Now, let's get serious and straight to the point: our goal is to build a client-side app which lists all contact names from the `Contact` app. It will also allow users to create, update, and delete contact names.

To do so, we'll proceed in different steps. We'll start slowly by deploying a client-side "Hello World" app, and we'll finish with a full contact app using vanillaJS. This tutorial is for everybody, from padawan to jedi, so don't be scared of it. We'll explain everything.

## What's VanillaJS?

The term VanillaJS actually means that you're about to write some pure javascript code, without any library. It's just a joke for people who think you could'nt survive without using Javascript framework. We could therefore say that VanillaJS `IS` Javascript.

# Let's write a new contact application for Cozy

## Source code

To see the fully working and finished version, you can go on this [github](https://github.com/lemelon/cozysdk-client-tuto/tree/vanillajs) repo.

## Links

To have a full understanding of what we're doing here, I'll advise you to read the following tutorial:
- [cozysdk-client handbook](https://github.com/cozy/cozysdk-client/blob/master/api.md)

## First step : Hello World !

Here we are, doing the traditionnal "Hello World" app that can make you want to start a new career. 

Starting from an empty repository, you will need a few files : First, the manifest `package.json` with some fields
- `name`, the name of your app (without space)
- `displayName`, the user readable name
- `description`, what the user will see when installing your app
- `cozy-type: "static"`, which tells Cozy your app doesnt need a server
- `icon-path`, a path to your app icon

Also, an `index.html` file needs to be at the root of your repository with your 'Hello World' written in it.

Once you have these, publish your app on [github](https://github.com/) and you should be able to install it from the store on your cozy. If you managed to deploy it, congratulations! If not, don't worry, we're here to help you: the most easy way to contact us is by joining our [irc channel](http://irc.lc/freenode/cozycloud). 


### Package a client-side application for installation into your cozy platform

To deploy an application without a server into your cozy platform, you need to do the following steps:

- Create an NPM package manifest in `package.json` into the root of your folder. The most important thing is to add `cozy-type: static` for specifying to the controller that it’s a client-side app. If your app is not `client-side`, you don’t need this line.
- Create an `index.html` file at the root of your folder. You can use any single page app (SPA) framework you want (angularjs, reactjs, backbonejs), or just static html/css pages.
- When you’re happy about your work, you can publish it on [github](https://github.com/).
- You can then go to the home of your Cozy, and at the bottom of the application manager, just type the URL of the repository of your wrapper, click install, wait a few seconds and enjoy!

Your app could be broken if the controller didn’t manage to do one of the following operations: clone it, install it or launch it. If your application has a `package.json` that has some syntax error for example, or your file that launches the app has'nt been found, your application will not work.

If you managed to deploy it, congratulations! If not, don't worry, we're here to help you: the most easy way to contact us is by joining our [irc channel](http://irc.lc/freenode/cozycloud).

### Source code

At the end of this step, your app should be similar to [this](https://github.com/lemelon/cozysdk-client-tuto/tree/v1.0). 

## Second step: Get contacts

First of all, please add [cozysdk-client.js](https://github.com/cozy/cozysdk-client/blob/master/dist/cozysdk-client.js) in your repository and link it into your html page.

In this step, if you go on the bottom of `app.js` file, you'll see: 

`document.addEventListener("DOMContentLoaded", updateContactList);` 

This function loads and initializes all the app: 

`updateContactList` will fire on load and retrieve all data from the `contact` app, related to the last activated event, and display them into an array.. 

To understand more deeply how things work in details, I'll advise you to look at how [addEventListener](https://developer.mozilla.org/fr/docs/Web/API/EventTarget/addEventListener) works.

`DOMContentLoaded` will not start until the HTML page is completely parsed but that does'nt include stylesheets, images...

So the different steps are as followed:
* 1. HTML parsing document
* 2. Load javascript content with `DOMContentLoaded`
* 3. `DOMContentLoaded` doesn't wait for css or images loading 

We can now start doing some coding. Our objectives here are simple: getting the list of contacts from your `contact` app, only with javascript. The good side effect of this, is to show you how simple it is to send requests to cozy-data-system, without worrying about which framework to chose.

So what we want to do here is getting all contacts and display them into an html array. To do so, you'll need to perform a [define request](https://github.com/cozy/cozysdk-client/blob/master/api.md#definerequestdoctype-name-request-callback) and a [run request](https://github.com/cozy/cozysdk-client/blob/master/api.md#rundoctype-name-params-callback). Nothing more.

The difficult part will be to render the result to an html page. For simplicity, we want to re-render the whole array every time it changes. So I'll need to create a`<tr>` and a `<td>` of HTML strings and use [innerHTML](https://developer.mozilla.org/fr/docs/Web/API/Element/innertHTML) to place it in your application.

The param of the render function is the object containing keys you want to concanate in the template.

### Source code

You can find the source code for this step [here](https://github.com/lemelon/cozysdk-client-tuto/tree/step1-vanilla)!

## Third step: Create, destroy or update a contact

### Event Handlers

I'v' decided to [attach a handler](http://www.w3schools.com/js/js_htmldom_eventlistener.asp) to events like `keypress` or `click`. 

So in our case:

```html

<tr data-id="contacts[i].id"> 
	<td>
		<input value="contacts[i].key" class="edit">
	</td> 
	<td>
		// event (onClick or keypress)
		<input type="button" class="update" value="Update">
	</td>
	<td>
		// event (onClick or keypress)
		<input type="button" class="destroy" value="Destroy">
	</td>
</tr>
```

`destroy` and `update` are inside `<tr>` and we attach an `onClick` and a `keypress` event with both the elements. Now if we don't attach a handler and we click on `destroy`, then eventHandler for `destroy` and `edit` will be executed. To prevent this, I decided to apply the useCapture parameter of addEventListener method. 

Thus, the second argument of `addEventListener` in `attachHandler` is giving us additional information about the event. In this case, if you want to know which mouse button was pressed, you can look at the event object’s which property.

### `create`

If you want to add a new contact, you'll actually need to fire a new event, pass it in the event object and it'll handle the DOM insertion and save the new contact. So we added a `listener` for the `add` button, so when the user clicks it, the function `onSendChanged` is called, we retrieve the value entered in the `contactName` field and pass it to [cozysdk.create](https://github.com/cozy/cozysdk-client/blob/master/api.md#createdoctype-attributes-callback), we also pass a callback, when the callback is called, our contact has been created, we then rerender the contact list to display it.

### `destroy`

If you want to remove a contact, the principle is quite similar but you also need to give it an Id in the parameter, to find the DOM element matching that ID. 

Finding the Id with the DOM is quite particular. What I did here in `getIDFromElement` is a recursive function: the function will not stop going back to itself untill `<tr data-id=[id]>` tag is reached. In other words, the Id will be returned when `parentNode` property recognizes an Id on the tag above. To be more visual and understand what I mean by `parentNode`, I can show you the `HTML` tag structure:

```html
// Second step... Bingo!! The dataId is found...
<tr data-id="contacts[i].id"> 
	<td>
		<input value="contacts[i].key" class="edit">
	</td> 
	// First step... No Id found...
	<td>
		// Initial step
		<input type="button" class="update" value="Update">
	</td>
	// First step... No Id found...
	<td>
		// Initial step
		<input type="button" class="destroy" value="Destroy">
	</td>
</tr>
```

In this example, the `parentNode` of `initial step` is `first step` and the `parentNode` of first step is `second step`. It's in this second step that the `data-id` is returned.

### `updateAttributes`

To update a contact you need to give `updateAttributes` an ID, the data to update, and a callback to fire when the update is complete.
