import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebSockets 1.1
Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Chat Coding Challenge")
    WebSocket{
        id:socket
        active: true
        url: "ws://localhost:8080"
        onTextMessageReceived: function(message){
            console.log("Recieved:", message)
            socket.sendTextMessage("I received (" + message + ")")
        }
    }
}
