## Map / Reduce requests

## DefineMapReduceView : create an index on your data.

You can create several view for each docType.

A view is composed of a map function and an optional reduce function.
The map and reduce functions can be passed as string or as a `Function` object.
The map function is applied to every document of a given docType.
In this function, you can **emit(key, value)**
This (key, value) pair is called an entry.
The entry are stored sorted by key in an index.
You can emit 0, 1 or N times for each doc.

#### I just want to sort
```javascript
cozysdk.defineMapReduceView('doctype', 'bydate', function (){
    emit(doc.date, doc);
});
```
and then,
```javascript
cozysdk.queryView('doctype', 'bydate', {});
// will give you all documents for this docType sorted by date.
```


#### More complex example
```javascript
cozysdk.defineMapReduceView('doctype', 'myview', function complexMap(){
    // oscar doesnt want to be included
    if(!doc.owner == 'oscar') {
        // always be careful : docs may not have all the fields you expect.
        if(doc.tags && doc.tags.forEach){
            doc.tags.forEach(function(tag){
                // the emit(key, value) function fill up couchdb index
                emit(tag.toLowerCase(), doc.someValue);
            }
        }
    }
});
```
```json
[
    { "_id": "doc1", "owner": "oscar", "tags": ["tagA"]      , "someValue": 7},
    { "_id": "doc2", "owner": "jane",  "tags": ["tagA", "tagB"] ,
                                                                "someValue": 8},
    { "_id": "doc3", "owner": "john",  "tags": ["taga"]      , "someValue": 9},
    { "_id": "doc4", "owner": "david", "tags": []         , "someValue": 10}
]
```

Will generate the following index
```
|   key  | value |  id  |
|--------|-------|------|
| taga   | 8     | doc2 |
| taga   | 9     | doc3 |
| tagb   | 8     | doc2 |
```

You can see that

- **doc1** has been discarded because its owner is oscar
- **doc2** has generated two entries
- **doc2** has generated one entry
- **doc4** has not generated any entry
- Entries get sorted by their key

You can emit any value, including arrays. So if you wanted to sort by owner and date, you can
```javascript
emit([doc.owner, doc.date], doc.someValue)
```

## Querying views

Once we have defined a view, we can then query it.

To get all entries for a key, we can use the **key** query parameter.
```javascript
cozysdk.queryView('doctype', 'myview', {key: "tagb"})
//-> {key: 'tagb', value: 8, id: 'doc2'}
```

If you pass no parameters, you will get every entries for this view.

To get entries for several keys at once, we can use the **keys** parameter.
To get entries for a range of keys, we can use the **startkey** & **endkey** parameters.

To reverse the sorting order, use the **descending** query params. Beware, that **startkey** and **endkey** will need to be reversed.

By default, query only returns key and values. You can use the **include_docs** parameter to include the documents with the results.

You can use the **skip** parameters to discard some results from the beginning and **limit** to discard some results from the end. It is however cleaner to paginate using **startkey** and **endkey**


You can replace queryView by  {@link module:mapreduce.destroyByView destroyByView} to destroy documents instead of retrieving them.

## Reduce function

## Some SQL equivalents

```SQL
SELECT title FROM notes WHERE author=john SORT BY date
```
```javascript
map    function(doc) { emit( [doc.author, doc.date], doc.title ); }
query  {"startkey": ["john"], "endkey": ["john", {}]}
// {} is greater than any string in couchdb sort order.
```

## Troubleshooting

### Map & Reduce functions are executed in couchdb server.

They can't use a function from outside of themselves. Inline all tools you may
need.

**BAD**
```
function isPair(x) {}
var map = function (doc){
    if(isPair(doc.field) emit(doc.id)
}
cozysdk.defineMapReduceView('doctype', 'pair', map)
```

### Map & Reduce functions can be applied to weird documents

Beware of null pointers.

**BAD** : `emit(doc.field.info)`
**GOOD**: `if(doc.field) emit(doc.field.info)`
