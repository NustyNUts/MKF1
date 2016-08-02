import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {
    id: keyboard
    //width: settings.width-buttonWidth - button1.anchors.leftMargin * 2
    height: 4 * buttonMargin + 5 * buttonHeightKeyboard
    width: textField.width + 2 * buttonMargin + 2 * buttonWidthKeyboard
    //height: 480
    color: "#00000000"
    property int buttonWidthKeyboard: window1.width/9.0
    property int buttonHeightKeyboard: window1.height/9.0
    //property var buttonWidthKeyboard: 100
    //property var buttonHeightKeyboard: 100
    property double buttonFontSize:buttonHeightKeyboard / 3.0
    property int buttonMargin:20
    property string keyBoardRes :"0";

    function setRes(arg){
        keyBoardRes = arg;
        textField.text = Qt.binding(function(){return keyBoardRes;})
    }


    property bool modeSKL : true
    function setMod(arg){
        modeSKL = arg
    }

    function buttonClick(arg){
        if(arg == "<-"){
            keyBoardRes = keyBoardRes.toString().substring(0,keyBoardRes.toString().length-1);
            if(keyBoardRes == "" || keyBoardRes == "-")
                keyBoardRes = "0";
        }
        else if(arg == "+/-"){
            keyBoardRes *= -1;
        } else if(arg == "+0.1"){
            keyBoardRes = Math.round(((parseFloat(keyBoardRes) + 0.1)*10))/10;
        }
        else if(arg == "-0.1"){
            keyBoardRes = Math.round(((parseFloat(keyBoardRes) - 0.1)*10))/10;
        } else {
            if(keyBoardRes == "0" && arg != ".")
                keyBoardRes = "";
            keyBoardRes += arg;
        }

        if(keyBoardRes.toString().indexOf(".") > 0){
            keyBoardRes = keyBoardRes.toString().substring(0,keyBoardRes.toString().indexOf(".")+2);
        }



        if(keyBoardRes >= 180){
            keyBoardRes = "180";
        } else if(keyBoardRes <= -180)
            keyBoardRes = "-180";

        textField.text = keyBoardRes;
    }

    signal saved()

    function getValue(){
        return parseFloat(keyBoardRes);
    }

    Component{
        id: keyboardButtonStyle

        ButtonStyle{
            label: Text {
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: helvetica.name
                font.pointSize: buttonFontSize
                color: window1.dayNight === false ?  "#7fff00": "black"
                text: control.text
              }

            background: Rectangle {
                border.width: control.pressed ? 5:1
                border.color: "#888"
                radius: 4
                color: dayNight === false ? "black" : "white"
            }
        }
    }

    Button{
        id: button0
        width: buttonWidthKeyboard
        height: buttonHeightKeyboard
        text: qsTr("0")
        anchors.left: buttonPoint.right
        anchors.leftMargin: buttonMargin
        anchors.top: button8.bottom
        anchors.topMargin: buttonMargin
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            buttonClick(text)
        }
    }
    Button{
        id: button1
        width: buttonWidthKeyboard
        height: buttonHeightKeyboard
        text: qsTr("1")
        anchors.left: textField.left
        anchors.leftMargin: 0
        anchors.top: textField.bottom
        anchors.topMargin: buttonMargin
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            buttonClick(text)
        }
    }
    Button{
        id: button2
        width: buttonWidthKeyboard
        height: buttonHeightKeyboard
        text: qsTr("2")
        anchors.left: button1.right
        anchors.leftMargin: buttonMargin
        anchors.top: textField.bottom
        anchors.topMargin: buttonMargin
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            buttonClick(text)
        }
    }
    Button{
        id: button3
        width: buttonWidthKeyboard
        height: buttonHeightKeyboard
        text: qsTr("3")
        anchors.left: button2.right
        anchors.leftMargin: buttonMargin
        anchors.top: textField.bottom
        anchors.topMargin: buttonMargin
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            buttonClick(text)
        }
    }
    Button{
        id: button4
        width: buttonWidthKeyboard
        height: buttonHeightKeyboard
        text: qsTr("4")
        anchors.left: button1.left
        anchors.leftMargin: 0
        anchors.top: button1.bottom
        anchors.topMargin: buttonMargin
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            buttonClick(text)
        }
    }
    Button{
        id: button5
        width: buttonWidthKeyboard
        height: buttonHeightKeyboard
        text: qsTr("5")
        anchors.left: button4.right
        anchors.leftMargin: buttonMargin
        anchors.top: button2.bottom
        anchors.topMargin: buttonMargin
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            buttonClick(text)
        }
    }
    Button{
        id: button6
        width: buttonWidthKeyboard
        height: buttonHeightKeyboard
        text: qsTr("6")
        anchors.left: button5.right
        anchors.leftMargin: buttonMargin
        anchors.top: button3.bottom
        anchors.topMargin: buttonMargin
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            buttonClick(text)
        }
    }
    Button{
        id: button7
        width: buttonWidthKeyboard
        height: buttonHeightKeyboard
        text: qsTr("7")
        anchors.left: button4.left
        anchors.leftMargin: -0
        anchors.top: button4.bottom
        anchors.topMargin: buttonMargin
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            buttonClick(text)
        }
    }
    Button{
        id: button8
        width: buttonWidthKeyboard
        height: buttonHeightKeyboard
        text: qsTr("8")
        anchors.left: button7.right
        anchors.leftMargin: buttonMargin
        anchors.top: button5.bottom
        anchors.topMargin: buttonMargin
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            buttonClick(text)
        }
    }
    Button{
        id: button9
        width: buttonWidthKeyboard
        height: buttonHeightKeyboard
        text: qsTr("9")
        anchors.left: button8.right
        anchors.leftMargin: buttonMargin
        anchors.top: button6.bottom
        anchors.topMargin: buttonMargin
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            buttonClick(text)
        }
    }
    Button{
        id: buttonSave
        width: buttonWidthKeyboard*2+20
        height: buttonHeightKeyboard
        text: qsTr(" Ввод")
        anchors.left: button0.right
        anchors.leftMargin: buttonMargin
        anchors.top: button9.bottom
        anchors.topMargin: buttonMargin
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            saved();
        }
    }
    Button{
        id: buttonPoint
        width: buttonWidthKeyboard
        height: buttonHeightKeyboard
        text: qsTr(".")
        anchors.left: button7.left
        anchors.leftMargin: 0
        anchors.top: button7.bottom
        anchors.topMargin: buttonMargin
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            buttonClick(text)
        }
    }
    Button{
        id: buttonDel
        anchors.left: textField.right
        anchors.leftMargin: buttonMargin
        anchors.top: textField.top
        anchors.topMargin: 0
        width: buttonWidthKeyboard
        height: buttonHeightKeyboard
        text: qsTr("<-")
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            buttonClick(text)
        }
    }
    Button{
        id: buttonPlusMinus
        anchors.left: button9.right
        anchors.top: buttonDel.bottom
        width: buttonWidthKeyboard
        height: buttonHeightKeyboard
        text: qsTr("+/-")
        anchors.leftMargin: buttonMargin
        anchors.topMargin: buttonMargin
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            buttonClick(text)
        }
    }
    Button{
        id: buttonPlus
        anchors.left: button9.right
        anchors.top: buttonPlusMinus.bottom
        width: buttonWidthKeyboard
        height: buttonHeightKeyboard
        text: qsTr("+0.1")
        anchors.leftMargin: buttonMargin
        anchors.topMargin: buttonMargin
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            buttonClick(text)
        }
    }
    Button{
        id: buttonMinus
        anchors.left: button6.right
        anchors.top: buttonPlus.bottom
        width: buttonWidthKeyboard
        height: buttonHeightKeyboard
        text: qsTr("-0.1")
        anchors.leftMargin: buttonMargin
        anchors.topMargin: buttonMargin
        style: keyboardButtonStyle
        onClicked: {
            compass.sound()
            buttonClick(text)
        }
    }
    TextField {
        id: textField
        width: buttonWidthKeyboard * 3 + buttonMargin * 2
        height: buttonHeightKeyboard
        z: 1
        readOnly: true
        placeholderText: qsTr("")
        text: keyBoardRes
        font.pixelSize: textField.height / 1.5
        font.family: helvetica.name
        style:
            TextFieldStyle{
            textColor:window1.dayNight === false ?"#7fff00" : "black"
            background: Rectangle{
                color: dayNight === false ? "black" : "white"
                border.color: "#888"
                radius: 4
                border.width: 1
            }
        }
    }


}

