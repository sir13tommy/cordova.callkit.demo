var exec = require('cordova/exec');

var CallKitPlugin = {

  setup: function (data, successCallback) {
    exec(successCallback, () => {}, "CallKitPlugin", "setup", [data]);
  },

  startOutgoingCall: function (data, successCallback, errorCallback) {
    exec(successCallback, errorCallback, "CallKitPlugin", "startOutgoingCall", [data]);
  },

  connectOutgoingCall: function (data, successCallback) {
    exec(successCallback, () => {}, "CallKitPlugin", "connectOutgoingCall", [data]);
  },

  endCall: function (data, successCallback, errorCallback) {
    exec(successCallback, errorCallback, "CallKitPlugin", "endCall", [data]);
  },

  handleIncomingCall: function (data, successCallback, errorCallback) {
    exec(successCallback, errorCallback, "CallKitPlugin", "handleIncomingCall", [data]);
  }
};

module.exports = CallKitPlugin;
