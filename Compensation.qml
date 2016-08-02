import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {
    id: comprect
    FontLoader { id: a_LCDNovaObl; source: "content/a_LCDNovaObl.ttf" }
    width: settings.width-buttonWidth - button1.anchors.leftMargin * 2
    height: window1.height
    property color textColor:window1.dayNight === false ? "#7fff00": "black"
    property real progressBarWidth: window1.width / 3.5
    property int progressBarHeight: window1.height / 14
    property int progressBarMargin: progressBarHeight / 2
    property int buttonWidthComrect: window1.width / 4
    property real buttonHeightComrect: window1.height / 7.5
    property int textFontSize:buttonHeightComrect / 3
    property int textWidth: window1.width / 24
    property real textHeight: window1.height / 19.6
    property var buttonMargin:20
    property int compState: 0

    property color compensationStatusBackgroundcolor: "white"
    color: "#00000000"


    Component{
        id: prBarStyle
        ProgressBarStyle{
            background: Rectangle {
                        radius: 2
                        color: window1.dayNight === false ? "black": "white"
                        border.color: window1.dayNight === false ?  "white":"black"
                        border.width: 1
                        implicitWidth: 200
                        implicitHeight: 24
                    }
            progress: Rectangle {
                       color: window1.dayNight === false ? "#0017E6":"#7fff00"
                       border.color: "steelblue"
                   }
        }
    }

    function changeColor()
    {
        compState = Qt.binding(function(){
        if(m_complable === "НОРМА" || m_complable ==="ОТКАЗ"||m_complable === "ВРЕМЯ"||m_complable === "ОШИБКА"){
            compass.sound();
            return 0;
        }
        else return 1;
        })
    }

    Connections{
        target:timerComp
        onTimeout: {
            compState = 0
            compass.ledOn()
            compass.setCompensationLabeltoDeafault()
        }
    }

    Image {


        id: compensationBackground
        width: buttonWidthComrect*2 + buttonMargin
        height: progressBarHeight*4+buttonMargin*4+buttonHeightComrect
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter


        ProgressBar {
            Connections {
                    target: compass
                    onBinsChanged: progressBarN.value = compass.getBins(7)
            }
            id: progressBarN

            width: buttonWidthComrect
            height: progressBarHeight
            anchors.left: button1.left
            anchors.leftMargin: 0
            anchors.top: button1.bottom
            anchors.topMargin: buttonMargin
            value: compass.getBins(0)
            maximumValue: 16.0
            style: prBarStyle
        }

        ProgressBar {
            Connections {
                    target: compass
                    onBinsChanged: progressBarNE.value = compass.getBins(6)
            }
            id: progressBarNE
            width: buttonWidthComrect
            height: progressBarHeight
            anchors.left: progressBarN.left
            anchors.leftMargin: 0
            anchors.top: progressBarN.bottom
            anchors.topMargin: buttonMargin
            value: compass.getBins(1)
            maximumValue: 16.0
            style: prBarStyle
        }

        ProgressBar {
            Connections {
                    target: compass
                    onBinsChanged: progressBarE.value = compass.getBins(5)
            }
            id: progressBarE
            width: buttonWidthComrect
            height: progressBarHeight
            anchors.left: progressBarNE.left
            anchors.leftMargin: 0
            anchors.top: progressBarNE.bottom
            anchors.topMargin: buttonMargin
            value: compass.getBins(2)
            maximumValue: 16.0
            style: prBarStyle
        }

        ProgressBar {
            Connections {
                    target: compass
                    onBinsChanged: progressBarSE.value = compass.getBins(4)
            }
            id: progressBarSE
            width: buttonWidthComrect
            height: progressBarHeight
            anchors.left: progressBarE.left
            anchors.leftMargin: 0
            anchors.top: progressBarE.bottom
            anchors.topMargin: buttonMargin
            value: compass.getBins(3)
            maximumValue: 16.0
            style: prBarStyle
        }

        ProgressBar {
            Connections {
                    target: compass
                    onBinsChanged: progressBarS.value = compass.getBins(3)
            }
            id: progressBarS
            width: buttonWidthComrect
            height: progressBarHeight
            anchors.left: progressBarN.right
            anchors.leftMargin: buttonMargin
            anchors.top: compensationStatus.bottom
            anchors.topMargin: buttonMargin
            value: compass.getBins(4)
            maximumValue: 16.0
            style: prBarStyle
        }

        ProgressBar {
            Connections {
                    target: compass
                    onBinsChanged: progressBarSW.value = compass.getBins(2)
            }
            id: progressBarSW
            width: buttonWidthComrect
            height: progressBarHeight
            anchors.left: progressBarNE.right
            anchors.leftMargin: buttonMargin
            anchors.top: progressBarS.bottom
            anchors.topMargin: buttonMargin
            value: compass.getBins(5)
            maximumValue: 16.0
            style: prBarStyle
        }

        ProgressBar {
            Connections {
                    target: compass
                    onBinsChanged: progressBarW.value = compass.getBins(1)
            }
            id: progressBarW
            width: buttonWidthComrect
            height: progressBarHeight
            anchors.left: progressBarE.right
            anchors.leftMargin: buttonMargin
            anchors.top: progressBarSW.bottom
            anchors.topMargin: buttonMargin
            value: compass.getBins(6)
            maximumValue: 16.0
            style: prBarStyle

        }
        ProgressBar {
            Connections {
                    target: compass
                    onBinsChanged: progressBarNW.value = compass.getBins(0)
            }
            id: progressBarNW
            width: buttonWidthComrect
            height: progressBarHeight
            anchors.left: progressBarSE.right
            anchors.leftMargin: buttonMargin
            anchors.top: progressBarW.bottom
            anchors.topMargin: buttonMargin
            value: compass.getBins(7)
            maximumValue: 16.0
            style: prBarStyle
        }

        Button {
            id: button1
            property int borderWidth:1
            width: buttonWidthComrect
            height: buttonHeightComrect
            text: compState === 0? "Начать":"Остановить"
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            style: ButtonStyle {
                    label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family: helvetica.name
                        font.pointSize: height / 5
                        font.bold: true
                        color: window1.dayNight === false ? "#7fff00": "black"
                        text: control.text
                      }
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 25
                        border.color: "#888"
                        border.width: button1.borderWidth
                        radius: 4
                        color:dayNight === false ? "black" : "white"
                    }
            }
            onPressedChanged: {
                button1.borderWidth= pressed === true? 5:1
            }

            onClicked:{
                compass.ledOn()
                if(compState === 0){
                    compass.initComp();
                    compState = 1;
                }
                else if(compState === 1){
                    compass.stopComp();
                    compState=0;
                }
            }
        }

//        Button {
//            id: button2
//            property int borderWidth:1
//            width: buttonWidthComrect
//            height: buttonHeightComrect
//            text: qsTr("Остановить")
//            anchors.left: button1.right
//            anchors.leftMargin: -85
//            anchors.topMargin: 219
//            anchors.top: parent.top
//            style: ButtonStyle {
//                    label: Text {
//                        renderType: Text.NativeRendering
//                        verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignHCenter
//                        font.family: helvetica.name
//                        font.pointSize: height / 5
//                        font.bold: true
//                        color: window1.dayNight === false ? "#7fff00": "black"
//                        text: control.text
//                      }
//                    background: Rectangle {
//                        implicitWidth: 100
//                        implicitHeight: 25
//                        border.width: button2.borderWidth
//                        border.color: "#888"
//                        radius: 4
//                        color:dayNight === false ? "black" : "white"
//                    }
//            }
//            onClicked:{
//                compass.ledOn()
//                compass.stopComp();
//            }
//            onPressedChanged: {
//                button2.borderWidth= pressed === true? 5:1
//            }
//        }



        Text {
            id: text1
            width: textWidth
            height: textHeight
            color: textColor
            text: qsTr("N")
            anchors.verticalCenter: progressBarN.verticalCenter
            anchors.horizontalCenter: progressBarN.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: textFontSize
            font.family: helvetica.name
        }

        Text {
            id: text2
            width: textWidth
            height: textHeight
            color: textColor
            text: qsTr("NE")
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: progressBarNE.horizontalCenter
            anchors.verticalCenter: progressBarNE.verticalCenter
            font.pixelSize: textFontSize
            font.family: helvetica.name
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: text3
            width: textWidth
            height: textHeight
            color: textColor
            text: qsTr("E")
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: progressBarE.horizontalCenter
            anchors.verticalCenter: progressBarE.verticalCenter
            font.pixelSize: textFontSize
            font.family: helvetica.name
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: text4
            width: textWidth
            height: textHeight
            color: textColor
            text: qsTr("SE")
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: progressBarSE.horizontalCenter
            anchors.verticalCenter: progressBarSE.verticalCenter
            font.pixelSize: textFontSize
            font.family: helvetica.name
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: text5
            width: textWidth
            height: textHeight
            color: textColor
            text: qsTr("S")
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: progressBarS.horizontalCenter
            anchors.verticalCenter: progressBarS.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: textFontSize
            font.family: helvetica.name
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: text6
            width: textWidth
            height: textHeight
            color: textColor
            text: qsTr("SW")
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: progressBarSW.horizontalCenter
            anchors.verticalCenter: progressBarSW.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: textFontSize
            font.family: helvetica.name
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: text7
            width: textWidth
            height: textHeight
            color: textColor
            text: qsTr("W")
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: progressBarW.horizontalCenter
            anchors.verticalCenter: progressBarW.verticalCenter
            font.pixelSize: textFontSize
            font.family: helvetica.name
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: text8
            width: textWidth
            height: textHeight
            color: textColor
            text: qsTr("NW")
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: progressBarNW.horizontalCenter
            anchors.verticalCenter: progressBarNW.verticalCenter
            z: 1
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: textFontSize
            font.family: helvetica.name
            verticalAlignment: Text.AlignVCenter
        }

        TextField
        {
            id:compensationStatus
            font.pixelSize: height/4
            font.family: helvetica.name
            width: buttonWidthComrect
            height: buttonHeightComrect
            text: m_complable
            anchors.left: button1.right
            anchors.leftMargin: buttonMargin
            anchors.top: parent.top
            anchors.topMargin: 0
            readOnly: true
            verticalAlignment : Text.AlignVCenter
            horizontalAlignment :Text.AlignHCenter
            style:
                TextFieldStyle{
                textColor:window1.dayNight === false ?"#7fff00" : "black"
                background: Rectangle{
                    id: compensationStatusBackground
                    color: m_complable === "" ? dayNight === false ? "black" : "white"
                                                : m_complable === "НОРМА"? "#34D31D"
                                                    : m_complable === "КАЛИБРОВКА"? "#FBFE9A"
                                                        :"#FB5D5B"

                }

            }
        }

    }
}
