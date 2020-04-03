import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

// Maybe change to ApplicationWindow
//ApplicationWindow{
Window {
    visible: true
    width: 640
    height: 480
    //flags: setMaximumHeight(480)
    //flags: Qt.WindowMaximized
     //setMaximumHeight(480), setMaximumWidth(640)
    //flags: setGeometry(0,0,640,480)

    title: qsTr("Chat Coding Challenge")

    // stack view used if back button needs to be implemented
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: UserLogin {}
    }
}
