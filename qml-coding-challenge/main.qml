import QtQuick 2.12
//import QtQuick.Controls 2.5 // ScrollView
import QtQuick.Controls 2.14

import QtQuick.Window 2.12
import QtWebSockets 1.1

// Once finished, possibly do "chattutorial" implementation
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


            var sendUsr = JSON.parse(message).name
            var recievedMsg = JSON.parse(message).message

            // Later Create Check to verify if user who sent data was
            // this particular user, if yes the make 'sendUsr' variable "(Me)"

            var displayString = sendUsr + ": " + recievedMsg
            chatTranscriptText.append(displayString)


            // Later Add check for JSON string, in order
            // to make the next line work
            //socket.sendTextMessage("I received (" + message + ")")
        }
    }

    // Users
    Rectangle {
        id: userArea
        x: 0
        y: 0
        width: 192                // 30 % of whole window
        height: 480
        color: "#290A4E"
        border.color: "black"
        border.width: 2
        //radius: 10
        // Title Area
        Rectangle{
            x: 0
            y: 0
            width: 192             // 30 % of whole window
            height: 25
            color: "#290A4E"
            border.color: "black" // for testing
            border.width: 2       // for testing
            Text {
                text: "Users"
                anchors.centerIn: parent
                font.family: "Montserrat"
                font.pointSize: 10.5
                color: "white"
            }
        }
        // User List Area
        Rectangle{
            x: 0
            y: 25
            width: 192           // 30 % of whole window
            height: 455
            color: "#290A4E"
            border.color: "red"
            border.width: 2


        }

    }

    Rectangle{
        id: conversationArea
        x: 192
        y: 0
        width: 448
        height: 480
        color: "white"
        border.color: "darkblue" // just for testing
        border.width: 2          // just for testing


        // Label (Conversation)
        Rectangle{
            x: 0 // relative to parent (where parent = conversationArea)
            y: 0
            width: 448
            height: 50
            color: "lightblue"
            Text{
                text: "Conversation"
                anchors.centerIn: parent
                font.family: "Montserrat"
                font.pointSize: 10.5
                color: "white"

            }
        }
//         Message Log
        Rectangle{
            id: messageLog
            x: 5
            y: 50
            width: 438 // 5 pixel margins
            height: 350 // 480 - 50(label) - 90(textArea) = 340 (changed)
            border.color: "black"
            border.width: 2
            radius: 5

            ScrollView{
                id: chatTranscirptScroll
                x: 5 // test value
                y: 5
                width: 428
                height: 340
                clip: true


                TextEdit{
                    id: chatTranscriptText
                    //width: chatTranscirptScroll.wdith
                    width: 428
                    height: chatTranscirptScroll.height
                    readOnly: true
                    textFormat: Text.RichText //enables HTML formatting
                    wrapMode: TextEdit.Wrap

                }
                // maybe add anchors

            }

        }



        // Text Input Area (Later Create a seperate file)
        Rectangle{
            id: textInputBox
            x: 5
            y: 405 // 390 + 5(margin)
            width: 338
            height: 70
            border.color: "black"
            border.width: 2
            radius: 5

            function sendData(){
                //var myData = { name: "Person 1", message: "My message"};
                if(textInput.text.length > 0){
                // later change Person1, to username which sent the message
                var userName = "Person 2"
                //var userName = (textInput.text).slice(0,5)
                var myData = { name: userName, message: textInput.text};
                var theData = JSON.stringify(myData)

                socket.sendTextMessage(theData)
                }
            }


            // do research on all fields
            TextInput{
                id: textInput

                color: "black"
                font.family: "Montserrat"
                font.pointSize: 10


                wrapMode: Text.WrapAnywhere
                anchors.fill: parent
                clip: true
                selectByMouse: true
                padding: 4

            }

        }

        Button{
            id: sendButton
            x: 348
            y: 405
            width: 95
            height: 70
            onClicked: textInputBox.sendData() // if have time add validation, to check if server is running or compatible

                Text{
                    id: buttonLabel
                    anchors.centerIn: parent
                    text: "Send"
                    //text: buttonName
                    color: "black"
                    font.family: "Montserrat"
                    font.pointSize: 10.5
                }
        }


    }


}
