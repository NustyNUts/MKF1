import QtQuick 2.0

import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1


Rectangle {
    id: deviTable
    width: settings.width-buttonWidth - button1.anchors.leftMargin * 2
    height: window1.height
    color: "#00000000"
    property int elementHeight: height / 9
    property int elementWidht: width / 6
    property bool stepTable: true //10-true,15-false
    property bool degaus: false //true -on, false-off
    function setDev(){
        tableModel.clear()
        if(stepTable == true)
            for(var i = 0;i<36;i++){
                if(degaus === true)
                    tableModel.append({"course":i*10,"corr":deviationDG10[i]})
                else
                    tableModel.append({"course":i*10,"corr":deviation10[i]})
            }
        else
            for(i = 0;i<24;i++){
                if(degaus)
                    tableModel.append({"course":i*15,"corr":deviationDG15[i]})
                else
                    tableModel.append({"course":i*15,"corr":deviation15[i]})
            }

    }

    Component{
        id:coefStyle

        ButtonStyle{
            label: Text {
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family:  helvetica.name
                font.pointSize: buttonFontSize
                color: window1.dayNight === false ?  "#7fff00": "black"
                text: control.text
              }

            background: Rectangle {
                border.color: dayNight === false ? "#7fff00" : "black"
                radius: 4
                color: dayNight === false ? "black" : "white"
            }
        }
    }
    Rectangle{
        width:elementWidht*5
        height:elementHeight*8
        anchors.centerIn: parent
    Button {
        id: butStepTable
        text: stepTable === true ? "10" : "15"
        anchors.leftMargin: 0
        anchors.topMargin: 0
        height: elementHeight
        width: elementWidht
        anchors.left: parent.left
        anchors.top: parent.top
        style: ButtonStyle {
            label: Text {
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family:  helvetica.name
                font.pointSize: buttonFontSize
                color: window1.dayNight === false ?  "#7fff00": "black"
                text: control.text
            }
            background: Rectangle {
                id:butStepTableBack
                implicitWidth: 100
                implicitHeight: 25
                border.width: control.pressed ? 5:1
                border.color: "#888"
                color: dayNight === false ? "black" : "white"
                radius: 4
            }
        }
        onClicked: {
            compass.sound()
            stepTable = !stepTable
            setDev()
        }
    }

    Button {
        id: butDegaus
        text: degaus === false? "РУ ВЫКЛ":"РУ ВКЛ"
        height: elementHeight
        width: elementWidht * 4
        anchors.top: butStepTable.top
        anchors.topMargin: 0
        anchors.left: butStepTable.right
        anchors.leftMargin: 0
        style: ButtonStyle {
            label: Text {
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family:  helvetica.name
                font.pointSize: buttonFontSize
                color: window1.dayNight === false ?  "#7fff00": "black"
                text: control.text
            }
            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 25
                border.width: control.pressed ? 5:1
                border.color: "#888"
                radius: 4
                color: window1.dayNight === false ? "black" : "white"

            }
        }
        onClicked: {
            compass.sound()
            degaus = !degaus
            setDev()
        }
    }
    Rectangle{
        id:deviA1

        height: elementHeight
        anchors.left: butStepTable.left
        anchors.leftMargin: 0
        anchors.top: butStepTable.bottom
        anchors.topMargin: 0
        width: elementWidht
        border.color: dayNight === false ? "#7fff00" : "black"
        radius: 4
        color: dayNight === false ? "black" : "white"
        Text {
            anchors.fill: parent
            text:"A"
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family:  helvetica.name
            font.pointSize: buttonFontSize
            color: window1.dayNight === false ?  "#7fff00": "black"
        }
    }
    Rectangle{
        id:deviB1
        border.color: dayNight === false ? "#7fff00" : "black"
        radius: 4
        color: dayNight === false ? "black" : "white"
        height: elementHeight
        anchors.left: deviA1.right
        anchors.leftMargin: 0
        anchors.top: butStepTable.bottom
        anchors.topMargin: 0
        width: elementWidht
        Text {
            anchors.fill: parent
            text:"B"
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family:  helvetica.name
            font.pointSize: buttonFontSize
            color: window1.dayNight === false ?  "#7fff00": "black"
        }

    }
    Rectangle{
        id:deviC1
        border.color: dayNight === false ? "#7fff00" : "black"
        radius: 4
        color: dayNight === false ? "black" : "white"
        height: elementHeight
        anchors.left: deviB1.right
        anchors.leftMargin: 0
        anchors.top: butStepTable.bottom
        anchors.topMargin: 0
        width: elementWidht
        Text {
            anchors.fill: parent
            text:"C"
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family:  helvetica.name
            font.pointSize: buttonFontSize
            color: window1.dayNight === false ?  "#7fff00": "black"
        }
    }
    Rectangle{
        id:deviD1
        border.color: dayNight === false ? "#7fff00" : "black"
        radius: 4
        color: dayNight === false ? "black" : "white"
        height: elementHeight
        anchors.left: deviC1.right
        anchors.leftMargin: 0
        anchors.top: butStepTable.bottom
        anchors.topMargin: 0
        width: elementWidht
        Text {
            anchors.fill: parent
            text:"D"
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family:  helvetica.name
            font.pointSize: buttonFontSize
            color: window1.dayNight === false ?  "#7fff00": "black"
        }
    }
    Rectangle{
        id:deviE1
        border.color: dayNight === false ? "#7fff00" : "black"
        radius: 4
        color: dayNight === false ? "black" : "white"
        height: elementHeight
        anchors.left: deviD1.right
        anchors.leftMargin: 0
        anchors.top: butStepTable.bottom
        anchors.topMargin: 0
        width: elementWidht
        Text {
            anchors.fill: parent
            text:"E"
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family:  helvetica.name
            font.pointSize: buttonFontSize
            color: window1.dayNight === false ?  "#7fff00": "black"
        }
    }


    Button {
        id: deviA
        text:degaus === false ? devCoef[0] :devCoefDG[0]
        height: elementHeight
        anchors.left: butStepTable.left
        anchors.leftMargin: 0
        anchors.top: deviA1.bottom
        anchors.topMargin: 0
        width: elementWidht
        style: coefStyle
    }
    Button {
        id: deviB
        text:degaus === false ? devCoef[1] :devCoefDG[1]
        height: elementHeight
        width: elementWidht
        anchors.top: deviB1.bottom
        anchors.topMargin: 0
        anchors.left: deviA.right
        anchors.leftMargin: 0
        style: coefStyle
    }
    Button {
        id: deviC
        text:degaus === false ? devCoef[2] :devCoefDG[2]
        height: elementHeight
        width: elementWidht
        anchors.top: deviC1.bottom
        anchors.topMargin: 0
        anchors.left: deviB.right
        anchors.leftMargin: 0
        style: coefStyle
    }
    Button {
        id: deviD
        text:degaus === false ? devCoef[3] :devCoefDG[3]
        height: elementHeight
        width: elementWidht
        anchors.top: deviD1.bottom
        anchors.topMargin: 0
        anchors.left: deviC.right
        anchors.leftMargin: 0
        style: coefStyle
    }
    Button {
        id: deviE
        text: degaus === false ?devCoef[4] :devCoefDG[4]
        height: elementHeight
        width: elementWidht
        anchors.top: deviE1.bottom
        anchors.topMargin: 0
        anchors.left: deviD.right
        anchors.leftMargin: 0
        style: coefStyle
    }

        TableView{
            id: table
            width: elementWidht*5
            height:elementHeight * 5
            anchors.topMargin: 0
            anchors.left: deviA.eft
            anchors.leftMargin: 0
            anchors.top: deviA.bottom
            style: TableViewStyle{
                backgroundColor:dayNight === false ? "black" : "white"
                rowDelegate :Rectangle{
                    height: elementHeight

                }
                headerDelegate:Rectangle{
                    border.width: 1
                    border.color: dayNight === false ? "#7fff00" : "black"
                    width: elementWidht
                    height:elementHeight
                    color: dayNight === false ? "black" : "white"
                    Text{
                        anchors.fill: parent
                        text: styleData.value
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: height/4
                        font.family: helvetica.name
                        color:window1.dayNight === false ?  "#7fff00": "black"
                    }
                }

                itemDelegate: Rectangle{

                    border.width: 1
                    border.color: dayNight === false ? "#7fff00" : "black"
                    color: dayNight === false ? "black" : "white"
                    Text{
                        anchors.fill: parent
                        text: styleData.value !== undefined  ? styleData.value : ""
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: height/3
                        font.family: helvetica.name
                        color:window1.dayNight === false ?  "#7fff00": "black"
                    }
                }
            }

            TableViewColumn {
                        id: courseColumn
                        title: "КK"
                        role: "course"


                        movable: false
                        resizable: false
                        width: table.width/2-1

                    }
            TableViewColumn {
                        id: dataColumn
                        title: "Дев."
                        role: "corr"
                        movable: false
                        resizable: false
                        width: table.width/2-1
                    }
            model:tableModel
        }



    ListModel{
        id:tableModel
        Component.onCompleted: {
            setDev();
        }
    }
}

//    Rectangle {
//        id: deviA1

//        width: elementWidht
//        height: elementHeight
//        text: "A"
//        anchors.top: butStepTable.bottom
//        anchors.left: butStepTable.left
//        anchors.leftMargin: 0
//        anchors.topMargin: 0
//        style: coefStyle
//    }

//    Rectangle {
//        Label{
//        id: deviB1

//        width: elementWidht
//        height: elementHeight
//        text:  "B"
//        anchors.top: butStepTable.bottom
//        anchors.left: deviA.right
//        anchors.leftMargin: 0
//        anchors.topMargin: 0
//        //style: coefStyle
//        }
//    }

//    Rectangle {
//        id: deviC1

//        width: elementWidht
//        height: elementHeight
//        text: "C"
//        anchors.top: butStepTable.bottom
//        anchors.left: deviB.right
//        anchors.leftMargin: 0
//        anchors.topMargin: 0
//        style: coefStyle
//    }

//    Rectangle {
//        id: deviD1

//        width: elementWidht
//        height: elementHeight
//        text: "D"
//        anchors.top: butStepTable.bottom
//        anchors.left: deviC.right
//        anchors.leftMargin: 0
//        anchors.topMargin: 0
//        style: coefStyle
//    }

//    Rectangle {
//        id: deviE1
//        width: elementWidht
//        height: elementHeight
//        text:"E"
//        anchors.top: butStepTable.bottom
//        anchors.left: deviD.right
//        anchors.leftMargin: 0
//        anchors.topMargin: 0
//        style: coefStyle
//    }


}
