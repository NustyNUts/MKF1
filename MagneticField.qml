import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {
    id: magneticField
    width: settings.width-buttonWidth - button1.anchors.leftMargin * 2
    height: window1.height
    //width: 1440
    //height: 980
    color: "#00000000"
    visible: true
    FontLoader { id: a_LCDNovaObl; source: "content/a_LCDNovaObl.ttf" }

    property real lcdWidth: window1.width/5
    property real lcdHeight: window1.height/12
    property real textWidth: window1.width/2
    property real textHeight: window1.height/7
    property int lcdFontSize:lcdHeight / 2.0
    property int buttonWidth: lcdWidth * 2
    property int buttonHeight: lcdHeight


    //-------------B C Z coef
    //-----B coef


//        Text{
//            id: textB
//            anchors.left: parent.left
//            anchors.leftMargin: 0
//            anchors.bottom:  textC.top
//            anchors.bottomMargin: lcdHeight-4
//            width:buttonWidth/4
//            height:buttonHeight
//            renderType: Text.NativeRendering
//            verticalAlignment: Text.AlignVCenter
//            horizontalAlignment: Text.AlignHCenter
//            text: qsTr("X")
//            font.pixelSize: textHeight / 1.8
//            color: window1.dayNight ===false ? "#7fff00":"black"
//            font.family:helvetica.name
//        }
        Rectangle{
            id: textB
            width:buttonWidth/4
            height:buttonHeight
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom:  textC.top
            anchors.bottomMargin: lcdHeight-5
            color:"transparent"
            Label{
                width:buttonWidth/4
                height:buttonHeight
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("X")
                font.pixelSize: textHeight / 2
                color: window1.dayNight ===false ? "#7fff00":"black"
                font.family:helvetica.name

            }
        }

    Rectangle
    {
        id: lcdCoefBRect
        y: window1.width/2.25
        z: 3
        width: lcdWidth
        height: lcdHeight
        border.width: 3
        border.color: window1.dayNight ===false ? "#7fff00":"black"
        color: window1.dayNight ===false ? "black" : "white"
        anchors.top:  textB.top
        anchors.topMargin: -5
        anchors.left: textB.right
        anchors.leftMargin: lcdHeight / 2
        Text
        {
            id: lcdB
            anchors.centerIn: parent
            text: coef_C+" мкТл"
            font.pixelSize: lcdFontSize
            font.family:helvetica.name
            color: window1.dayNight ===false ? "#7fff00":"black"
        }
    }

    //--------C coef

    Rectangle{
        id: textC
        width:buttonWidth/4
        height:buttonHeight
        color:"transparent"
        anchors.left: textB.left
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        Label{
            width:buttonWidth/4
            height:buttonHeight
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Y")
            font.pixelSize: textHeight / 2
            color: window1.dayNight ===false ? "#7fff00":"black"
            font.family:helvetica.name

        }
    }
    Rectangle
    {
        id: lcdCoefCRect
        z: 3
        width: lcdWidth
        height: lcdHeight
        border.width: 3
        border.color: window1.dayNight ===false ? "#7fff00":"black"
        color: window1.dayNight ===false ? "black" : "white"
        anchors.left: textC.right
        anchors.leftMargin: lcdHeight / 2
        anchors.top: textC.top
        anchors.topMargin: -5
        Text
        {
            id: lcdC

            anchors.centerIn: parent
            text: coef_B+" мкТл"
            font.pixelSize:lcdFontSize
            font.family:helvetica.name
            color: window1.dayNight ===false ? "#7fff00":"black"
        }
    }


    //----Z coef
    Rectangle{
        id: textZ
        width:buttonWidth/4
        height:buttonHeight
        anchors.left: textC.left
        anchors.leftMargin: 0
        anchors.top: textC.bottom
        anchors.topMargin: lcdHeight
        color:"transparent"
        Label{
            width:buttonWidth/4
            height:buttonHeight
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Z")
            font.pixelSize: textHeight / 2
            color: window1.dayNight ===false ? "#7fff00":"black"
            font.family:helvetica.name

        }
    }
    Rectangle
    {

        id: lcdCoefZRect
        y: window1.width/2.25
        z: 3
        width: lcdWidth
        height: lcdHeight
        border.width: 3
        border.color: window1.dayNight ===false ? "#7fff00":"black"
        color: window1.dayNight ===false ? "black" : "white"
        anchors.left: textZ.right
        anchors.leftMargin: lcdHeight / 2
        anchors.top: textZ.top
        anchors.topMargin: -5
        Text
        {
            id: lcdZ
            anchors.centerIn: parent
            text: coef_Z+" мкТл"
            font.pixelSize: lcdFontSize
            font.family:helvetica.name
            color: window1.dayNight ===false ? "#7fff00":"black"
        }
    }
    //---------------

    Button {
        id: button1
        width: buttonWidth
        height: buttonHeight
        text: logMsg
        visible: false
        anchors.top: lcdCoefBRect.bottom
        anchors.topMargin: lcdHeight
        anchors.left: textB.left
        anchors.leftMargin: 0
        style: ButtonStyle {
            label: Text {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: helvetica.name
                    font.pointSize: height / 2.5
                    color: "black"
                    text: control.text
                }
              }
        onClicked:{
            compass.sound()
            compass.startWriteLog();
        }
    }
}
