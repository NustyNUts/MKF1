import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {
    id: deviationRect
    width: settings.width-buttonWidth - button1.anchors.leftMargin * 2
    height: window1.height
//    width: 800
//    height: 600
    color: "#00000000"
    property int devFontSize: window1.width/53.333333333
    property bool modeSKL : true
    property int  deviationCourse: 0
    property string delta : ""
    property int buttonNumber : 0
    property bool degaus : false
    property string degausButText : "РУ выкл"


    property int buttonWidthKeyboard: window1.width/10
    property int buttonHeightKeyboard: window1.height/9.0
    property int buttonFontSize:buttonHeightKeyboard / 3.0
    property real buttonMargin:buttonHeightKeyboard / 5.5

    function setMod(arg){
        modeSKL = arg
    }

    Component{
        id:butDevStyle
        ButtonStyle{
            property color textColor: "white"
            property color backgroundColor: "white"

            label: Text {
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family:  helvetica.name
                font.pointSize: buttonFontSize
                color: textColor
                text: control.text
              }

            background: Rectangle {
                border.width: control.pressed ? 5:1
                border.color: "#888"
                radius: 4
                color: backgroundColor
            }
        }
    }

    function changeDeviationButtonState(deviationCourse){
        if(deviationCourse === 1){
            buttonC0.buttonTextC0Color =  "black" ;
            buttonC0.buttonC0Color = deviationCourse === 1 ? "#42e73a":dayNight === false ? "black" : "white";
        } else if(deviationCourse === 2){
            buttonC45.buttonTextC45Color =  "black" ;
            buttonC45.buttonC45Color = deviationCourse === 2 ? "#42e73a":dayNight === false ? "black" : "white";
        } else if(deviationCourse === 3){
            buttonC90.buttonTextC90Color = dayNight === false ? deviationCourse === 3 ?"black":"#7fff00": "black" ;
            buttonC90.buttonC90Color = deviationCourse === 3 ? "#42e73a":dayNight === false ? "black" : "white";
        } else if(deviationCourse === 4){
            buttonC135.buttonTextC135Color = dayNight === false ? deviationCourse === 4 ?"black":"#7fff00": "black" ;
            buttonC135.buttonC135Color = deviationCourse === 4 ? "#42e73a":dayNight === false ? "black" : "white";
        } else if(deviationCourse === 5){
            buttonC180.buttonTextC180Color =  "black" ;
            buttonC180.buttonC180Color = deviationCourse === 5 ? "#42e73a":dayNight === false ? "black" : "white";
        } else if(deviationCourse === 6){
            buttonC225.buttonTextC225Color =  "black" ;
            buttonC225.buttonC225Color = deviationCourse === 6 ? "#42e73a":dayNight === false ? "black" : "white";
        }else if(deviationCourse === 7){
            buttonC270.buttonTextC270Color =  "black" ;
            buttonC270.buttonC270Color = deviationCourse === 7 ? "#42e73a":dayNight === false ? "black" : "white";
        }else if(deviationCourse === 8){
            buttonC315.buttonTextC315Color =  "black" ;
            buttonC315.buttonC315Color = deviationCourse === 8 ? "#42e73a":dayNight === false ? "black" : "white";
        }
    }

    function deviationButtonsStateReset(){
        buttonC0.buttonC0Color = Qt.binding(function(){return dayNight === false ? "black" : "white";})
        buttonC45.buttonC45Color = Qt.binding(function(){return dayNight === false ? "black" : "white";})
        buttonC90.buttonC90Color = Qt.binding(function(){return dayNight === false ? "black" : "white";})
        buttonC135.buttonC135Color = Qt.binding(function(){return dayNight === false ? "black" : "white";})
        buttonC180.buttonC180Color = Qt.binding(function(){return dayNight === false ? "black" : "white";})
        buttonC225.buttonC225Color = Qt.binding(function(){return dayNight === false ? "black" : "white";})
        buttonC270.buttonC270Color = Qt.binding(function(){return dayNight === false ? "black" : "white";})
        buttonC315.buttonC315Color = Qt.binding(function(){return /*deviationCourse === 8 ? "#42e73a":*/dayNight === false ? "black" : "white";})

        buttonC0.buttonTextC0Color = Qt.binding(function(){return dayNight === false ? deviationCourse != 1 ?"#7fff00":"black": "black" ;})
        buttonC45.buttonTextC45Color = Qt.binding(function(){return  dayNight === false ? deviationCourse != 2 ?"#7fff00": "black":"black"  ;})
        buttonC90.buttonTextC90Color = Qt.binding(function(){return  dayNight === false ?deviationCourse != 3 ?"#7fff00": "black":"black"  ;})
        buttonC135.buttonTextC135Color = Qt.binding(function(){return  dayNight === false ? deviationCourse != 4 ?"#7fff00": "black":"black"  ;})
        buttonC180.buttonTextC180Color = Qt.binding(function(){return dayNight === false ? deviationCourse != 5 ?"#7fff00": "black":"black"  ;})
        buttonC225.buttonTextC225Color = Qt.binding(function(){return dayNight === false ? deviationCourse != 6 ?"#7fff00": "black":"black"  ;})
        buttonC270.buttonTextC270Color = Qt.binding(function(){return dayNight === false ? deviationCourse != 7 ?"#7fff00": "black":"black"  ;})
        buttonC315.buttonTextC315Color = Qt.binding(function(){return dayNight === false ? deviationCourse != 8 ?"#7fff00": "black":"black"  ;})

    }


    function setDelta(num,value){
        if(degaus == false)
            compass.addDelta(num, value);
        else
        {
            compass.addDeltaDegaus(num, value);
        }
    }



    Image {
        id: compensationBackground
        visible: true
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent


        NewKeyboard{
            id:keyboardDisplay
            width: 640
            height: 480
            anchors.topMargin: buttonHeightKeyboard + buttonMargin
            anchors.left: buttonC0.left
            anchors.leftMargin: 0
            anchors.top: buttonC0.bottom
            z:2
            Connections{
                onSaved:{
                    setDelta(deviationCourse,keyboardDisplay.getValue());
                    changeDeviationButtonState(deviationCourse);
                }
            }
            Component.onCompleted: {
                deviationButtonsStateReset();
                keyboardDisplay.setRes(0)
            }
        }

        Button {
            id: buttonC0
            property color buttonC0Color: deviationCourse === 1 ? "#42e73a":"white"
            property color buttonTextC0Color: "white"
            width: buttonWidthKeyboard
            height: buttonHeightKeyboard
            text: qsTr("0")
            x: buttonWidth/4
            y: buttonHeight/2
            style: ButtonStyle {
                    label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family:  helvetica.name
                        font.pointSize: devFontSize
                        color: buttonC0.buttonTextC0Color
                        text: control.text
                      }
                    background: Rectangle {
                        id: buttonC0backGround
                        implicitWidth: 100
                        implicitHeight: 25
                        border.width: deviationCourse === 1 ? 5:1
                        border.color: deviationCourse === 1 ?"#277B14":"#888"
                        radius: 4
                        color: buttonC0.buttonC0Color
                    }
            }
            onClicked: {
                deviationCourse = 1
                degaus === false ? keyboardDisplay.setRes(compass.getDelta(deviationCourse)) : keyboardDisplay.setRes(compass.getDeltaDegaus(deviationCourse))
                compass.sound()
            }
        }

        Button {
            id: buttonC45
            property color buttonC45Color: "white"
            property color buttonTextC45Color:"white"
            width: buttonWidthKeyboard
            height: buttonHeightKeyboard
            text: qsTr("45")
            anchors.top: buttonC0.top
            anchors.topMargin: 0
            anchors.left: buttonC0.right
            anchors.leftMargin: 2
            style: ButtonStyle {
                label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family:  helvetica.name
                        font.pointSize: devFontSize
                        color: buttonC45.buttonTextC45Color
                        text: control.text
                      }
                background: Rectangle {
                    id: buttonC45backGround
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: deviationCourse === 2 ? 5:1
                    border.color: deviationCourse === 2 ?"#277B14":"#888"
                    radius: 4
                    color: buttonC45.buttonC45Color
                }
            }
            onClicked: {
                deviationCourse = 2
                degaus === false ? keyboardDisplay.setRes(compass.getDelta(deviationCourse)) : keyboardDisplay.setRes(compass.getDeltaDegaus(deviationCourse))
                compass.sound()
            }
        }

        Button {
            id: buttonC90
            property color buttonC90Color: deviationCourse === 3 ? "#42e73a":"white"
            property color buttonTextC90Color:"black"
            width: buttonWidthKeyboard
            height: buttonHeightKeyboard
            text: qsTr("90")
            anchors.top: buttonC0.top
            anchors.topMargin: 0
            anchors.left: buttonC45.right
            anchors.leftMargin: 2
            style: ButtonStyle {
                label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family:  helvetica.name
                        font.pointSize: devFontSize
                        color: buttonC90.buttonTextC90Color
                        text: control.text
                      }
                background: Rectangle {
                    id: buttonC90backGround
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: deviationCourse === 3 ? 5:1
                    border.color: deviationCourse === 3 ?"#277B14":"#888"
                    radius: 4
                    color: buttonC90.buttonC90Color
                }
            }
            onClicked: {
                deviationCourse = 3
                degaus === false ? keyboardDisplay.setRes(compass.getDelta(deviationCourse)) : keyboardDisplay.setRes(compass.getDeltaDegaus(deviationCourse))
                compass.sound()
            }
        }

        Button {
            id: buttonC135
            property color buttonC135Color: deviationCourse === 4 ? "#42e73a":"white"
            property color buttonTextC135Color: "black"
            width: buttonWidthKeyboard
            height: buttonHeightKeyboard
            text: qsTr("135")
            anchors.top: buttonC0.top
            anchors.topMargin: 0
            anchors.left: buttonC90.right
            anchors.leftMargin: 2
            style: ButtonStyle {
                label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family:  helvetica.name
                        font.pointSize: devFontSize
                        color: buttonC135.buttonTextC135Color
                        text: control.text
                      }
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: deviationCourse === 4 ? 5:1
                    border.color: deviationCourse === 4 ?"#277B14":"#888"
                    radius: 4
                    color: buttonC135.buttonC135Color
                }
            }
            onClicked: {
                deviationCourse = 4
                degaus === false ? keyboardDisplay.setRes(compass.getDelta(deviationCourse)) : keyboardDisplay.setRes(compass.getDeltaDegaus(deviationCourse))
                compass.sound()
            }
        }

        Button {
            id: buttonC180
            property color buttonC180Color: deviationCourse === 5 ? "#42e73a":"white"
            property color buttonTextC180Color:"black"
            width: buttonWidthKeyboard
            height: buttonHeightKeyboard
            text: qsTr("180")
            anchors.left: buttonC0.left
            anchors.leftMargin: 0
            anchors.top: buttonC0.bottom
            anchors.topMargin: 2
            style: ButtonStyle {
                    label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family:  helvetica.name
                        font.pointSize: devFontSize
                        color: buttonC180.buttonTextC180Color
                        text: control.text
                      }
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 25
                        border.width: deviationCourse === 5 ? 5:1
                        border.color: deviationCourse === 5 ?"#277B14":"#888"
                        radius: 4
                        color: buttonC180.buttonC180Color
                    }
            }
            onClicked: {
                deviationCourse = 5
                degaus === false ? keyboardDisplay.setRes(compass.getDelta(deviationCourse)) : keyboardDisplay.setRes(compass.getDeltaDegaus(deviationCourse))
                compass.sound()
            }
        }

        Button {
            id: buttonC225
            property color buttonC225Color: deviationCourse === 6 ? "#42e73a":"white"
            property color buttonTextC225Color:"black"
            width: buttonWidthKeyboard
            height: buttonHeightKeyboard
            text: qsTr("225")
            anchors.top: buttonC45.bottom
            anchors.topMargin: 2
            anchors.left: buttonC180.right
            anchors.leftMargin: 2
            style: ButtonStyle {
                    label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family:  helvetica.name
                        font.pointSize: devFontSize
                        color: buttonC225.buttonTextC225Color
                        text: control.text
                      }
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 25
                        border.width: deviationCourse === 6 ? 5:1
                        border.color: deviationCourse === 6 ?"#277B14":"#888"
                        radius: 4
                        color: buttonC225.buttonC225Color
                    }
            }
            onClicked: {
                deviationCourse = 6
                degaus === false ? keyboardDisplay.setRes(compass.getDelta(deviationCourse)) : keyboardDisplay.setRes(compass.getDeltaDegaus(deviationCourse))
                compass.sound()
            }
        }

        Button {
            id: buttonC270
            property color buttonC270Color: deviationCourse === 7 ? "#42e73a":"white"
            property color buttonTextC270Color:"black"
            width: buttonWidthKeyboard
            height: buttonHeightKeyboard
            text: qsTr("270")
            anchors.top: buttonC90.bottom
            anchors.topMargin: 2
            anchors.left: buttonC225.right
            anchors.leftMargin: 2
            style: ButtonStyle {
                label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family:  helvetica.name
                        font.pointSize: devFontSize
                        color: buttonC270.buttonTextC270Color
                        text: control.text
                      }
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: deviationCourse === 7 ? 5:1
                    border.color: deviationCourse === 7 ?"#277B14":"#888"
                    radius: 4
                    color: buttonC270.buttonC270Color
                }
            }
            onClicked: {
                deviationCourse = 7
                degaus === false ? keyboardDisplay.setRes(compass.getDelta(deviationCourse)) : keyboardDisplay.setRes(compass.getDeltaDegaus(deviationCourse))
                compass.sound()
            }
        }

        Button {
            id: buttonC315
            property color buttonC315Color: deviationCourse === 8 ? "#42e73a":"white"
            property color buttonTextC315Color:"black"
            width: buttonWidthKeyboard
            height: buttonHeightKeyboard
            text: qsTr("315")
            anchors.top: buttonC135.bottom
            anchors.topMargin: 2
            anchors.left: buttonC270.right
            anchors.leftMargin: 2
            style: ButtonStyle {
                    label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family:  helvetica.name
                        font.pointSize: devFontSize
                        color: buttonC315.buttonTextC315Color
                        text: control.text
                      }
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 25
                        border.width: deviationCourse === 8 ? 5:1
                        border.color: deviationCourse === 8 ?"#277B14":"#888"
                        radius: 4
                        color: buttonC315.buttonC315Color
                    }
            }
            onClicked: {
                deviationCourse = 8
                degaus === false ? keyboardDisplay.setRes(compass.getDelta(deviationCourse)) : keyboardDisplay.setRes(compass.getDeltaDegaus(deviationCourse))
                compass.sound()
            }
        }
        Button {
            id: degausButton
            width: buttonWidthKeyboard
            height: buttonHeightKeyboard
            text: degaus===false ? degausButText="РУ выкл" : degausButText = "РУ вкл"
            anchors.left: buttonC135.right
            anchors.leftMargin: 5
            anchors.top: buttonC0.top
            anchors.topMargin: 0
            signal degausClicked()
            Component.onCompleted: {
                degausButton.degausClicked.connect(deviationButtonsStateReset)
            }
            style: ButtonStyle {
                label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family:  helvetica.name
                        font.pointSize: devFontSize
                        color:  window1.dayNight === false ? "#7fff00":"black"
                        text: control.text
                      }
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 25
                        border.width: control.pressed ? 5 : 1
                        border.color: "#888"
                        radius: 4
                        color:  window1.dayNight === false ? "black": "white"
                    }
            }
            onClicked: {
                degaus = !degaus
                degausClicked();
                console.log(degaus);
                degaus === false ? keyboardDisplay.setRes(deviationCourse !== 0? compass.getDelta(deviationCourse):"0") : keyboardDisplay.setRes(deviationCourse !== 0? compass.getDeltaDegaus(deviationCourse): "0")
                compass.sound()
            }
        }

        Button {
            id: buttonDo
            width: buttonWidthKeyboard
            height: buttonHeightKeyboard
            anchors.left: buttonC315.right
            anchors.leftMargin: 5
            anchors.top: buttonC315.top
            anchors.topMargin: 0
            text: qsTr("Расcчитать")
            signal doClicked()

            Component.onCompleted: {
                buttonDo.doClicked.connect(deviationButtonsStateReset)
            }
            style: ButtonStyle {
                    label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family:  helvetica.name
                        font.pointSize: buttonFontSize/2
                        color: window1.dayNight === false ? "#7fff00":"black"
                        text: control.text
                      }
                    background:
                        Rectangle {
                        implicitWidth: 100
                        implicitHeight: 25
                        border.width: control.pressed ? 5 : 1
                        border.color: "#888"
                        radius: 4
                        color: window1.dayNight === false ? "black": "white"
                        }
            }
            onClicked: {
                compass.getDevCoef()
                buttonDo.doClicked()
                compass.sound()
            }
        }

    }
}

