/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        this.receivedEvent('deviceready');
    },

    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
        this.id = id;

        this.setup();

        // bind buttons events
        document.getElementById('startOutgoingCall').addEventListener('click', app.startOutgoingCall.bind(app), false)
        document.getElementById('connectOutgoingCall').addEventListener('click', app.connectOutgoingCall.bind(app), false)
        document.getElementById('endCall').addEventListener('click', app.endCall.bind(app), false)
        document.getElementById('handleIncomingCall').addEventListener('click', app.handleIncomingCall.bind(app), false)
    },

    log: function(method, data, hasError) {
        let logStr = 'Callkit.' + method + ': ' + data;
        if (hasError) {
            console.log('Error ' + logStr);
        } else {
            console.log(logStr);
        }
    },

    setup: function() {
        this.log('setup', 'run')
        CallKitPlugin.setup({
            appName: 'Chanty',
            supportsVideo: false
        }, (result) => {
            this.log('setup', result);
        });
    },

    startOutgoingCall: function() {
        this.log('startOutgoingCall', 'run');
        CallKitPlugin.startOutgoingCall({
            title: 'Call fucking fagots'
        }, (result) => {
            this.log('startOutgoingCall', result);
        }, (error) => {
            this.log('startOutgoingCall', error, true);
        });
    },

    connectOutgoingCall: function() {
        this.log('connectOutgoingCall', 'run');
        CallKitPlugin.connectOutgoingCall({
            uuid: this.id
        }, (result) => {
            this.log('connectOutgoingCall', result)
        });
    },

    endCall: function() {
        this.log('endCall', 'run');
        CallKitPlugin.endCall({
            uuid: this.id
        }, (result) => {
            this.log('endCall', result);
        }, (error) => {
            this.log('endCall', error, true);
        });
    },
    
    handleIncomingCall: function() {
        this.log('handleIncomingCall', 'run')
        CallKitPlugin.handleIncomingCall({
            title: 'Call from fucking fagots',
            hasVideo: false
        }, (result) => {
            this.log('handleIncomingCall', result)
        }, (error) => {
            this.log('handleIncomingCall', error, true);
        });
    }
};

app.initialize();

function startOutgoingCall() {
    app.startOutgoingCall();
}