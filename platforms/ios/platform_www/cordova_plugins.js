cordova.define('cordova/plugin_list', function(require, exports, module) {
  module.exports = [
    {
      "id": "com.chanty.call-kit.CallKitPlugin",
      "file": "plugins/com.chanty.call-kit/www/callKitPlugin.js",
      "pluginId": "com.chanty.call-kit",
      "clobbers": [
        "window.CallKitPlugin"
      ]
    }
  ];
  module.exports.metadata = {
    "cordova-plugin-whitelist": "1.3.4",
    "com.chanty.call-kit": "0.1.0"
  };
});