import QtQuick 2.12

Rectangle{
    id: button

    property string label

    //radius: 1
    antialiasing: true // possibly don't need
    color: "lightgrey"

    Text{
        id: buttonLabel
        anchors.centerIn: parent
        text: label
        color: "black"
        font.family: "Montserrat"
        font.pointSize: 10.5
    }

    signal buttonClick()

    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent
        onClicked: buttonClick()
    }

    /* Do some research on the following section of code */
    // Scale the button when pressed
    scale: buttonMouseArea.pressed ? 1.1 : 1.0
    // Animate the scale property change
    Behavior on scale { NumberAnimation { duration: 55 } }


}
