# Daenerys

This is a command line application that converts JSON documents into executable HTTP requests.

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
daenerys run myrequest.json
```
