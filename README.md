# Daenerys

### Daenerys is a command line application that converts static JSON documents into executable HTTP requests.

It lets you store complex API calls as simple JSON files. 

You might use it for functional testing of APIs or automating complex HTTP calls.

It is heavily inspired by the Chrome Postman extension

Requests can be written in YAML or JSON

> ALL YOUR HTTP ARE BELONG TO JSON

![](https://s.yimg.com/os/publish-images/tv/2014-03-18/2599ab90-aead-11e3-b1dd-f95b1df1b844_Deanerys-Targaryen-white-stalion.jpg)

## Example

Lets create a text file containing a HTTP request that we can execute.

```javascript
{ "url": "http://google.com",
  "method": "GET",
  "headers": "",
  "body" : ""
}
```

We can now run this from the command line so:

```
cabal run "examples/simple-get.json"
```

## Low level API

Some of the Haskell HTTP libraries can border on overly complex sometimes.

Daenerys also provides a much nicer DSL for doing HTTP requests in Haskell with minimial fuss. 

```haskell
exampleRequest = InternalRequest {
    requestUrl    = "http://requestb.in/1d1a1121"
  , requestMethod = "GET"
  , headers = Just $ fromList [("Content-Type", "application/json")]
  , body = Just "HELLO WORLD"
}

response = runRequest exampleRequest
```
