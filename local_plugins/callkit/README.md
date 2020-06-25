# CallKit Plugin



## Functionality 



### Setup

Call at the start of app to setup `CallKit`

```js
CallKitPlugin.setup(
  {
    'appName': string, // app name to display, optional
    'icon': string, // icon to display in base64, optional
    'supportsVideo' boolean // optional, false by default
  },
  (result) => {
    // if result is empty then CallKit did setup and all good
    // but this callback might be triggred later with { 'action': 'reset' } result
    // It means that you should reset CallKit and call setup again
  }
)
```



### Start Outgoing Call

Call when you want to start outgoing call

```js
CallKitPlugin.startOutgoingCall(
  {
    'title': string // title of call (usually name of persone you call)
  },
  (result) => {
    // if call started result will be
    // { 
    //   'action': 'started' 
    //   'uuid': string // call uuid
    // }
    // after call started user can press end call button in this case result will be
    // { 
    //   'action': 'ended' 
    //   'uuid': string // call uuid
    // }
  },
  (error) => {
    // error contains description of whats happend
  }
)
```



### Connect Outgoing Call

Call when outgoing call already started and connected with server to start show user call timer

```js
CallKitPlugin.connectOutgoingCall(
  {
    'uuid': string // call uuid
  },
  (result) => {
    // result will be
    // { 'action': 'connected' }
  }
)
```



### End Call

Call when you want to end ongoing call

```js
CallKitPlugin.endCall(
  {
    'uuid': string // call uuid
  },
  (result) => {
    // if call ended successfully result will be
    // {  'action': 'ended' }
  },
  (error) => {
    // error contains description of whats happend
  }
)
```



### Handle Incoming Call

Call when you receive incoming call to show native ui

```js
CallKitPlugin.handleIncomingCall(
  {
    'title': string, // title of call (usually name of persone you call)
    'hasVideo': boolean // optional, false by default
  },
  (result) => {
    // user will be able to choose between answering or cancelling call
    // if user answered call result will be
    // { 
    //   'action': 'answered' 
    //   'uuid': string // call uuid
    // }
    // if user cancel call OR pressed end call after call was answered
    // result will be
    // { 
    //   'action': 'ended' 
    //   'uuid': string // call uuid
    // }
  },
  (error) => {
    // error contains description of whats happend
  }
)
```