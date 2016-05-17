## The notion of docType
Cozy is based on couchdb, where all documents are stored in a single store,
to simplify management and enable permissioning, every document created
by cozy or an applicaiton should have a **docType**,
which identify the type of a document.

You can use existing docType, such as *Contact*, *Note*, *Event*, ... or
pick your own.

## Permissions
To use a docType, your app needs to ask the permissions in its
package.json
```json
    "cozy-permissions": {
        "Contact": {
            "description": "Pick a contact to talk to."
        }
    }
```

`description` is going to be showned when a user installs your application. So I advise you to be persuasive and explain why it needs to access your `Contact` data.

If the data-system doesn't recognize a docType name, it will create a new one and you'll be able to interact with it. You can use doctype from any other app in cozy, and any other app can use the docType of your application. Try to keep in mind that another app can create a document with your docType and an unexpected structure.

## How do I know the fields of a cozy application ?

Open any cozy app in github and head over to `server/models/xxxx.coffee` to see what attributes are created by cozy applications.
