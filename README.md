# Daenerys

This is a command line application that converts JSON documents into executable HTTP requests.

It lets you store complex API calls as simple JSON files. You might use it for testing APIs or automating HTTP calls.

It is heavily inspired by the Chrome Postman extension

## Example

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
