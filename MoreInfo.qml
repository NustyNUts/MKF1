import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {
    id: moreInfoRect
//    width: settings.width-buttonWidth - button1.anchors.leftMargin * 2
//    height: window1.height
    width: 1440
    height: 980
    color: "#00000000"
    visible: true
    FontLoader { id: a_LCDNovaObl; source: "content/a_LCDNovaObl.ttf" }

    property real lcdWidth: window1.width/8
    property real lcdHeight: window1.height/12
    property real textWidth: window1.width/2
    property real textHeight: window1.height/6
    property int lcdFontSize:lcdHeight / 2.0
    property int buttonWidth: lcdWidth * 2
    property int buttonHeight: lcdHeight

    //--------roll and pitch
    //-----roll

    Label{
        id:textRoll
        text: qsTr("Дифферент")
        anchors.left: parent.left
        anchors.leftMargin: window1.width/8
//        anchors.top: parent.top
//        anchors.topMargin: window1.height/2 - lcdHeight*2
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: lcdHeight
        font.pixelSize: lcdHeight/1.5
        color: window1.dayNight ===false ? "#7fff00":"black"
        font.family:helvetica.name
    }
    Rectangle
    {
        id: lcdRollRect
        z: 3
        width: lcdWidth
        height: lcdHeight
        border.width: 2
        border.color: window1.dayNight ===false ? "#7fff00":"black"
        color: window1.dayNight ===false ? "black" : "white"
        anchors.left: textRoll.right
        anchors.leftMargin: 20
        anchors.top: textRoll.top
        anchors.topMargin: -10
        Text
        {
            id: lcdRoll
            anchors.centerIn: parent
            text: m_pitch+"°"
            font.pixelSize: lcdFontSize
            font.family:helvetica.name
            color: window1.dayNight ===false ? "#7fff00":"black"
        }
    }


    //-----pitch
    Label{
        id:textPitch
        text: qsTr("Крен")
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -lcdHeight*2
        anchors.left: textRoll.left
        anchors.leftMargin: 0
        font.pixelSize: lcdHeight/1.5

        color: window1.dayNight ===false ? "#7fff00":"black"
        font.family:helvetica.name
    }
    Rectangle
    {
        id: lcdPitchRect
        y: window1.height/3.379310345
        z: 3
        width: lcdWidth
        height: lcdHeight
        border.width: 2
        border.color: window1.dayNight ===false ? "#7fff00":"black"
        color: window1.dayNight ===false ? "black" : "white"
        anchors.top: textPitch.top
        anchors.topMargin: -10
        anchors.left: textRoll.right
        anchors.leftMargin: 20
        Text
        {
            id: lcdPitch
            anchors.centerIn: parent
            text: m_roll+"°"
            font.pixelSize: lcdFontSize
            font.family:helvetica.name
            color: window1.dayNight ===false ? "#7fff00":"black"
        }
    }


//    Button {
//        id: button1
//        width: buttonWidth
//        height: buttonHeight
//        text: logMsg
//        visible: false
//        anchors.top: lcdCoefBRect.bottom
//        anchors.topMargin: lcdHeight
//        anchors.left: textB.left
//        anchors.leftMargin: 0
//        style: ButtonStyle {
//            label: Text {
//                    renderType: Text.NativeRendering
//                    verticalAlignment: Text.AlignVCenter
//                    horizontalAlignment: Text.AlignHCenter
//                    font.family: helvetica.name
//                    font.pointSize: height / 2.5
//                    color: "black"
//                    text: control.text
//                }
//              }
//        onClicked:{
//            compass.sound()
//            compass.startWriteLog();
//        }
//    }
}
