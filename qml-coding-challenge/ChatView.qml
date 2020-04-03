import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtWebSockets 1.1

Page{
    id: root
    property string currentUser
    //property string currentUserID
    property int numUsersConnected: 0
    //property var connectedUsers: []

    WebSocket{
        id:socket
        active: true
        url: "ws://localhost:8080"
        onTextMessageReceived: function(message){
            console.log("Recieved:", message)

            // check if data recieved is a JSON object
            if(isJSON(message) === false){

                socket.sendTextMessage(currentUser + " received (" + message + ")")
            } else{


                if(JSON.parse(message).dataType === "message"){

                    var sendUsr = JSON.parse(message).name
                    var recievedMsg = JSON.parse(message).message

                    var displayString
                    if(sendUsr === currentUser){
                        displayString = "(Me): " + recievedMsg
                    } else {
                        displayString = sendUsr + ": " + recievedMsg
                    }

                    chatTranscriptText.append(displayString)

                } else if(JSON.parse(message).dataType === "makeConnections"){
                    chatTranscriptText.append("connections were made")
                    // for new connection, add all users to users board
                    //chatTranscriptText.append(JSON.parse(message).name + " has connected")
                    addAllUsers(JSON.parse(message).connectedUsers)


                } else if(JSON.parse(message).dataType === "addUsr"){
                    // when new user, connect that user to users board
                    chatTranscriptText.append("user was added")
                    console.log("This is the new name " + JSON.parse(message).name)
                    addUser(JSON.parse(message).name)

                } else if(JSON.parse(message).dataType === "usrDisconnect"){
                    chatTranscriptText.append(JSON.parse(message).name + " has disconnected")
                    removeUser(JSON.parse(message).name)
                } else{
                    chatTranscriptText.append("An Error Has Occured")
                }
            }
        }
    }

    function isJSON (something) {
        if (typeof something != 'string')
            something = JSON.stringify(something);

        try {
            JSON.parse(something);
            return true;
        } catch (e) {
            return false;
        }
    }

    function addUser(user){
        if(user !== currentUser){
        connectedUsrsListModel.append({displayedUser: user})
        console.log(user)
        }
        numUsersConnected++
        console.log("Num Users: " + numUsersConnected)
    }


    function addAllUsers(userList){

        var userListLength = countProperties(userList)

        for(var i = 0; i < userListLength; i++){
            if(userList[i] !== currentUser){
                if(userList[i] !== undefined){
                    connectedUsrsListModel.append({displayedUser: userList[i]})
                    console.log("User at i is " + userList[i])
                    numUsersConnected++
                    console.log("Num Users: " + numUsersConnected)
                }
            }
        }
    }

    function removeUser(user){
        console.log("The user to be deleted is " + user)
        for(var i = 0; i < numUsersConnected; i++){
            if(user === connectedUsrsListModel.get(i).displayedUser){
                connectedUsrsListModel.remove(i)
                numUsersConnected--
            }
        }
    }

    //https://stackoverflow.com/questions/956719/number-of-elements-in-a-javascript-object
    function countProperties(obj) {
        return Object.keys(obj).length;
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

            ListView{
                id: connectedUsrsListView
                anchors.fill: parent
                model: connectedUsrsListModel
                delegate: Button{
                    x: 0
                    y: 0
                    width: 192
                    height: 25
                    scale: pressed ? 1.1 : 1
                    Behavior on scale { NumberAnimation { duration: 100 } }
                    background: Rectangle{
                        color: "lightblue"
                        opacity: enabled ?  1 : 0.3 // possibly remove later
                    }
                    Text{
                        text: displayedUser
                        anchors.centerIn: parent
                        //anchors.baseline: parent
                        color: "black"
                        font.family: "Montserrat"
                        font.pointSize: 10.5
                    }

                }
            }

            ListModel{
                id: connectedUsrsListModel
            }

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
            color: "white"
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
                    font.family: "Montserrat"
                    font.pointSize: 10.5
                    //text: recievedMessages.name + ": " + recievedMessages.message
                    //font.preferShaping: false //may be use, read that in can improve performance
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

                if(textInput.text.length > 0){

                var userName = currentUser
                var myData = {
                        dataType: "message",
                        name: userName,
                        message: textInput.text,
                        UUID: "NULL",
                        connectedUsers: {}
                        };
                var theData = JSON.stringify(myData)

                socket.sendTextMessage(theData)
                textInput.clear()

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

        // Possibly create scroll capability for text input
        Button{
            id: sendButton
            x: 348
            y: 405
            width: 95
            height: 70
            onClicked: textInputBox.sendData()  // if have time add validation, to check if server is running or compatible

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


