import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Window {
    id: window1
    width: 800
    height: 600
    title: qsTr("Compass")
    visibility: "Windowed"
    //visibility: "FullScreen"

    FontLoader { id: helvetica; source: "content/HelveticaLight.ttf" }
    property string gradientcolor0: "#FF7C7C7C"
    property string gradientcolor1: "#FF4E4E4E"
    property string sourseCompass360: "content/compass360day.png"
    property string sourseCompass10: "content/compass10day.png"
    property string sourceBackground: "content/backgroundDay.png"
    property bool dayNight: true
    property int statesWidth: lcdDisplay.width / 3
    property int statesHeight: lcdDisplay.height / 1.5


    Rectangle
    {
        id: rectangle1
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        //width: 1440
        //height: 980

        function closeSettingsDisplay(){
            //settingsDisplay.settingsSlided = false;
            if(settingsDisplay.settingsSlided === true)
                slideLCDBack.start();
        }

        Connections {
            target: compass
            onCloseSettingsViewSignal: {
              rectangle1.closeSettingsDisplay()
            }
        }

        SettingsQML
        {
            id:settingsDisplay
            property bool settingsSlided: false
            width: window1.width
            height: window1.height
            anchors.right: parent.right
            anchors.rightMargin: -window1.width
            z:3
        }
        Image {
            id: backgrnCompass
            width: window1.height
            height: backgrnCompass.width
            property bool slided: false
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 0
            z: 1
            source: sourceBackground
            Image {
                id: smallNeedle
                //x: 454
                //y: 16
                width: 4
                height: backgrnCompass.width / 4
                anchors.horizontalCenterOffset: -1
                anchors.verticalCenterOffset: -backgrnCompass.width / 4 - height / 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "content/needleSmall.png"
            }
        }
        ParallelAnimation {
            id: slideForward
            PropertyAnimation {
                target: backgrnCompass
                properties: "slided"
                to: true
                duration: 0
            }
            PropertyAnimation {
                target: backgrnCompass
                properties: "anchors.horizontalCenterOffset"
                to: -window1.width/4+window1.width/14.4
                duration: 200
            }
            PropertyAnimation {
                target: settingsDisplay
                properties: "anchors.rightMargin"
                to: 0
                duration: 200
            }
        }
        ParallelAnimation {
            id: slideBack
            PropertyAnimation {
                target: backgrnCompass
                properties: "slided"
                to: false
                duration: 0
            }
            PropertyAnimation {
                target: backgrnCompass
                properties: "anchors.horizontalCenterOffset"
                to: 0
                duration: 200
            }
            PropertyAnimation {
                target: settingsDisplay
                properties: "anchors.rightMargin"
                to: -settingsDisplay.width
                duration: 200
            }
        }

        ParallelAnimation {
            id: slideLCDForward
            PropertyAnimation {
                target: settingsDisplay
                properties: "settingsSlided"
                to: true
                duration: 0
            }
            PropertyAnimation {
                target: lcdDisplay
                properties: "anchors.horizontalCenterOffset"
                to: window1.width / 2 - lcdDisplay.width / 2 - settingsDisplay.buttonWidth / 10
                duration: 200
            }
            PropertyAnimation {
                target: lcdDisplay
                properties: "anchors.verticalCenterOffset"
                to: -window1.height / 2 + lcdDisplay.height / 2 + settingsDisplay.buttonHeight / 2
                duration: 200
            }
            PropertyAnimation {
                target: lcdDisplay
                properties: "border.width"
                to: 1
                duration: 200
            }
            PropertyAnimation {
                target: settingsDisplay
                properties: "anchors.rightMargin"
                to: 0
                duration: 200
            }
        }
        ParallelAnimation{
            id:butSettings
            PropertyAnimation{
                target:menuButton
                properties:"width"
                to:settingsDisplay.buttonWidth
                duration: 200
            }
            PropertyAnimation{
                target:menuButton
                properties:"height"
                to:settingsDisplay.buttonHeight
                duration: 200
            }
        }
        ParallelAnimation{
            id:butMain
            PropertyAnimation{
                target:menuButton
                properties:"width"
                to:window1.width/7.0
                duration: 200
            }
            PropertyAnimation{
                target:menuButton
                properties:"height"
                to:window1.height/10.0
                duration: 200
            }
        }
        ParallelAnimation {
            id: slideLCDBack
            PropertyAnimation {
                target: settingsDisplay
                properties: "settingsSlided"
                to: false
                duration: 0
            }
            PropertyAnimation {
                target: lcdDisplay
                properties: "anchors.horizontalCenterOffset"
                to: 10
                duration: 200
            }
            PropertyAnimation {
                target: lcdDisplay
                properties: "anchors.verticalCenterOffset"
                to: 0
                duration: 200
            }

            PropertyAnimation {
                target: lcdDisplay
                properties: "border.width"
                to: 0
                duration: 200
            }
            PropertyAnimation {
                target: settingsDisplay
                properties: "anchors.rightMargin"
                to: -window1.width
                duration: 200
            }
        }
        Image {
            id: compass10
            x: 100
            width: compass360.width
            height: compass10.width
            anchors.centerIn: backgrnCompass
            z: 1
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 0
            source: sourseCompass10
            transform: Rotation{
                angle: -fract_part*3.6
                axis.z: 1
                origin.x: compass10.width/2
                origin.y: compass10.height/2
                Behavior on angle
                   {
                       SpringAnimation
                       {
                           spring: 2.5
                           damping: 0.7
                       }
                   }
            }
        }

        Image {
            id: compass360
            anchors.centerIn: backgrnCompass
            z: 1
            width: backgrnCompass.width
            height: backgrnCompass.width
            source: sourseCompass360
            transform: Rotation{
                id: rotation1
                angle: -angle_value
                axis.z: 1
                origin.x: compass360.width/2
                origin.y: compass360.height/2
                Behavior on angle
                   {
                       SpringAnimation
                       {
                           spring: 1.9
                           damping: 0.3
                       }
                   }
            }

        }
        Rectangle {
            id: background
            color: dayNight === true? "#8db1b9":"#0c2132"
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent
            z: 0

        }
        Rectangle{
            opacity: acc_state === 0? 1:0
            width: window1.width/13
            height: window1.height /14
            z: 2
            anchors.top: parent.verticalCenter
            anchors.topMargin: -lcdDisplay.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 0
            radius: 5
            border.color: "red"
            border.width: 2

            color:"transparent"
            Text{
                id: accState

                anchors.fill: parent
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: helvetica.name
                font.pointSize: height / 3
                color: "red"
                text: "AKK"
            }
        }

        Rectangle{
            id: tmkStateText
            z: 2
            color: "#00000000"
            width: window1.width/20
            height: 40
            radius: 5
            anchors.top: parent.verticalCenter
            anchors.topMargin: lcdDisplay.height /2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 0
            border.width: 2
            border.color: dayNight === false ? "#7fff00" : "black"
            Text{
                id:tmkState
                anchors.fill: parent
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: helvetica.name
                font.pointSize: height / 3
                color: dayNight === false ? "#7fff00" : "black"
                text: "MK"
                Component.onCompleted: {
                    tmkState.text = Qt.binding(function(){

                    if(trueMagneticCourse === 0)
                        return "KK";
                    else if(trueMagneticCourse === 1)
                        return "MK";
                    else if(trueMagneticCourse === 2)
                        return "ИК";
                    })
                }
            }
        }


        Rectangle{
            width: 40
            height: 40
            radius: 5
            z: 2
            color: "#00000000"
            anchors.top:tmkStateText.top
            anchors.topMargin: 0
            anchors.right: tmkStateText.left
            anchors.rightMargin: 10
            border.width: 2
            border.color: dayNight === false ? "#7fff00" : "black"
            opacity: m_dempf === 0 ? 0:1
            Text{
                id: course_state_text
                z: 2
                anchors.fill: parent
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: helvetica.name
                font.pointSize: height / 3
                color: dayNight === false ? "#7fff00" : "black"
                text: "Д"
                anchors.topMargin: 0
                opacity: m_dempf === 0 ? 0:1
            }
        }
        Rectangle{
            id: ruStateText
            z: 2
            radius: 5
            color: "#00000000"
            border.width: 2
            border.color: dayNight === false ? "#7fff00" : "black"
            width: tmkStateText.width
            height: 40
            anchors.top: tmkStateText.top
            anchors.topMargin: 0
            anchors.left: tmkStateText.right
            anchors.leftMargin: 10
            opacity: m_degaus === 0 ? 0:1
            Text{
                anchors.fill: parent
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: helvetica.name
                font.pointSize: height / 3
                color: dayNight === false ? "#7fff00" : "black"
                text: "РУ"
            }

        }
        Rectangle
        {
            id: lcdDisplay
            z: 4
            width: window1.width/4
            height: window1.height/6

            radius: 4
            border.color: "#878787"
            border.width: 0
            color: dayNight === false ? "#000000" : "#faf0e6"
            anchors.horizontalCenter: backgrnCompass.horizontalCenter
            anchors.verticalCenter: backgrnCompass.verticalCenter
            anchors.horizontalCenterOffset: 10
            anchors.verticalCenterOffset: 0
            FontLoader { id: a_LCDNovaObl; source: "content/a_LCDNovaObl.ttf" }
            Text
            {
                id: lcdNumbers
                anchors.centerIn: parent
                text: full_angle+"°"
                //text: comp === false ?full_angle+"°":"-----"
                font.pixelSize: window1.width/14
                font.family: helvetica.name
                style: Text.Outline
                styleColor: "black"
                color: dayNight === false ? "#7fff00" : "black"
            }
        }

        Button
        {
            id: menuButton
            width: window1.width/7.0
            height: window1.height/10.0
            text: settingsDisplay.settingsSlided === false ? "Настройки":"Компас"
            anchors.right: parent.right
            anchors.rightMargin: settingsDisplay.buttonWidth / 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            z:4
            style: ButtonStyle {
                background: Rectangle{
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: control.pressed? 2 : 1
                    border.color: "#888"
                    radius: 4
                    color: dayNight === false ? "black" : "white"

                }

                label: Text {
                        id:menuText
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family: helvetica.name
                        color: dayNight === false ? "#7fff00" : "black"
                        font.pointSize: settingsDisplay.buttonFontSize
                        text: control.text
                      }
            }
            onClicked:{
                compass.sound()
                settingsDisplay.settingsSlided === false ? slideLCDForward.start():slideLCDBack.start();
                settingsDisplay.settingsSlided === false ? butMain.start():butSettings.start();
                //compass.startSettingsViewControlTimer(300000);
//                settingsDisplay.settingsSlided === true ? tmkState.visible = false : tmkState.visible = true
//                settingsDisplay.settingsSlided === true ? dempfButton.visible = false : dempfButton.visible = true
                settingsDisplay.close()
            }

        }




//        Button{
//            id: tmkState
//            y: 520
//            width: menuButton.width
//            height: menuButton.height
//            anchors.left: parent.left
//            anchors.leftMargin: 32
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 20
//            style: ButtonStyle {
//                label: Text {
//                        id:tmkStateText
//                        renderType: Text.NativeRendering
//                        verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignHCenter
//                        font.family: helvetica.name
//                        font.pointSize: tmkState.height / 3
//                        color: "black"
//                        text: "MK"
//                        Component.onCompleted: tmkStateText.text = Qt.binding(function(){
//                            if(trueMagneticCourse === 0)
//                                return "KK";
//                            else if(trueMagneticCourse === 1)
//                                return "MK";
//                            else if(trueMagneticCourse === 2)
//                                return "ИК";
//                        })
//                      }
//            }
//            onClicked:{
//                compass.sound()
//                compass.changeTrueMagneticCourse()
//            }
//        }
    }




}

