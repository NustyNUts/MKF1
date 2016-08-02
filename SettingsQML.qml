import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {
    id: settings
    //width: window1.width
    //height: window1.height
    width: 800
    height: 600
    property int buttonWidth:window1.width / 4
    property int buttonHeight:window1.height / 12
    property int buttonFontSize:buttonHeight / 3
    property int buttonNum:0
    property int butState: 0 // 0-main, 1-settings
    property int degaus: 0
    property int pageLeftMargin:mainButtons.width
    property int butLeftMargin:window1.width - settingsButtons.width//for left
    property int butTopMargin:2

    function allAnimStop(){
        slideMoreInfoForward.stop();
        slidePassDialForward.stop();
        slideBackgroundForward.stop();
        slideKeybordForward.stop();
        slideDeviationForward.stop();
        slideCompForward.stop();
        slideDeviTableForward.stop();
        slideMagFielForward.stop();
        slideParamForward.stop();
    }

    function close(){
        showMainBut.start();
        allAnimStop()
        slideCompBack.start();
        butState =0;
        buttonNum = 0;
    }



    function setA(){
        compass.setA(keyboardDisplay.getValue());
    }
    function setSKL(){
        compass.setSKL(keyboardDisplay.getValue());
    }

    ParallelAnimation{
        id:showSettingsBut
        PropertyAnimation{
            target:mainButtons
            properties: "anchors.leftMargin"
            to:window1.width
            duration:0
        }
        PropertyAnimation{
            target:settingsButtons
            properties: "anchors.leftMargin"
            to:butLeftMargin
            duration:0
        }
    }
    ParallelAnimation{
        id:showMainBut
        PropertyAnimation{
            target:settingsButtons
            properties: "anchors.leftMargin"
            to:window1.width
            duration:0
        }
        PropertyAnimation{
            target:mainButtons
            properties: "anchors.leftMargin"
            to:butLeftMargin
            duration:0
        }
    }


    ParallelAnimation {
        id: slideDeviTableForward
        PropertyAnimation {
            target: deviTable
            properties: "anchors.rightMargin"
            to: pageLeftMargin
            duration: 300
        }
    }
    ParallelAnimation {
        id: slideMoreInfoForward
        PropertyAnimation {
            target: moreInfoDisp
            properties: "anchors.rightMargin"
            to: pageLeftMargin
            duration: 300
        }
    }
    ParallelAnimation {
        id: slideMagFielForward
        PropertyAnimation {
            target: magField
            properties: "anchors.rightMargin"
            to: pageLeftMargin
            duration: 300
        }
    }
    Rectangle
    {
        id: backgroundviewer
        x: 0
        y: 0
        width: settings.width - buttonWidth - calibBut.anchors.leftMargin * 2
        height: settings.height
        color: "#00000000"
        anchors.rightMargin: -backgroundviewer.width
        anchors.right: parent.right
        z:2


    }
    ParallelAnimation{
        id:slidePassDialForward
        PropertyAnimation{
            target:passDial
            properties: "anchors.rightMargin"
            to: pageLeftMargin
            duration: 300
        }
    }
    ParallelAnimation{
        id:passDialClose
        PropertyAnimation{
            target:passDial
            properties: "visible"
            to: false
            duration:5
        }
    }
    ParallelAnimation{
        id:passDialAccept
        PropertyAnimation{
            target:passDial
            properties: "visible"
            to: false
            duration:1000
        }
    }

    ParallelAnimation {
        id: slideBackgroundForward
        PropertyAnimation {
            target: backgroundviewer
            properties: "anchors.rightMargin"
            to: pageLeftMargin
            duration: 300
        }
    }
    ParallelAnimation {
        id: slideKeybordForward
        PropertyAnimation {
            target: keyboardDisplay
            properties: "anchors.rightMargin"
            to: pageLeftMargin
            duration: 300
        }
    }
    ParallelAnimation {
        id: slideDeviationForward
        PropertyAnimation {
            target: deviationDisplay
            properties: "anchors.rightMargin"
            to: pageLeftMargin
            duration: 300
        }
    }
    ParallelAnimation {
        id: slideCompForward
        PropertyAnimation {
            target: compensationDisplay
            properties: "anchors.rightMargin"
            to: pageLeftMargin
            duration: 300
        }
    }
    ParallelAnimation {
        id: slideParamForward
        PropertyAnimation {
            target: paramDisplay
            properties: "anchors.rightMargin"
            to: pageLeftMargin
            duration: 300
        }
    }
    ParallelAnimation {
        id: slideCompBack
        PropertyAnimation {
            target: passDial
            properties: "anchors.rightMargin"
            to: -compensationDisplay.width
            duration: 0
        }
        PropertyAnimation {
            target: compensationDisplay
            properties: "anchors.rightMargin"
            to: -compensationDisplay.width
            duration: 0
        }
        PropertyAnimation {
            target: deviTable
            properties: "anchors.rightMargin"
            to: -compensationDisplay.width
            duration: 0
        }
        PropertyAnimation {
            target: keyboardDisplay
            properties: "anchors.rightMargin"
            to: -keyboardDisplay.width
            duration: 0
        }
        PropertyAnimation {
            target: deviationDisplay
            properties: "anchors.rightMargin"
            to: -deviationDisplay.width
            duration: 0
        }
        PropertyAnimation {
            target: moreInfoDisp
            properties: "anchors.rightMargin"
            to: -moreInfoDisp.width
            duration: 0
        }
        PropertyAnimation {
            target: magField
            properties: "anchors.rightMargin"
            to: -magField.width
            duration: 0
        }
        PropertyAnimation {
            target: backgroundviewer
            properties: "anchors.rightMargin"
            to: -backgroundviewer.width
            duration: 0
        }
        PropertyAnimation {
            target: paramDisplay
            properties: "anchors.rightMargin"
            to: -paramDisplay.width
            duration: 0
        }
    }
    Rectangle {
        id: settingsBackground
        z: 1
        anchors.fill: parent
        //source: (m_background === 0 ? "content/steel4.png" :( m_background === 1 ? "content/steel3.png":(m_background === 2 ? "content/steel2.png":(m_background === 3 ? "content/wood.png":(m_background === 4 ? "content/steel.png":"content/steel4.png")))))
        color: window1.dayNight === false ? "#0c2132" :"#8cb1b9"
        ModesPage
           {
               id:paramDisplay
               width: settings.width-buttonWidth - calibBut.anchors.leftMargin * 2
               height: settings.height
               anchors.rightMargin: -compensationDisplay.width
               anchors.right: parent.right
               z:2
           }
        MoreInfo
           {
               id:moreInfoDisp
               width: settings.width-buttonWidth - calibBut.anchors.leftMargin * 2
               height: settings.height
               anchors.rightMargin: -compensationDisplay.width
               anchors.right: parent.right
               z:2
           }
        MagneticField
           {
               id:magField
               width: settings.width-buttonWidth - calibBut.anchors.leftMargin * 2
               height: settings.height
               anchors.rightMargin: -compensationDisplay.width
               anchors.right: parent.right
               z:2
           }
        DeviTable{
            id:deviTable
            width: settings.width-buttonWidth - calibBut.anchors.leftMargin * 2
            height: settings.height
            anchors.rightMargin: -compensationDisplay.width
            anchors.right: parent.right
            z:2
        }
        PasswordDial{
            id:passDial
            width: settings.width-buttonWidth - calibBut.anchors.leftMargin * 2
            height: settings.height
            anchors.rightMargin: -compensationDisplay.width
            anchors.right: parent.right
            z:2
        }

        Compensation
        {
            id:compensationDisplay
            width: settings.width-buttonWidth - calibBut.anchors.leftMargin * 2
            height: settings.height
            anchors.rightMargin: -compensationDisplay.width
            anchors.right: parent.right
            z:2
        }
        Deviation
        {
            id:deviationDisplay
            width: settings.width-buttonWidth - calibBut.anchors.leftMargin * 2
            height: settings.height
            anchors.rightMargin: -deviationDisplay.width
            anchors.right: parent.right
            z:2
        }

        NewKeyboard
        {
            id:keyboardDisplay
            //width: settings.width-buttonWidth - calibBut.anchors.leftMargin * 2
            //height: settings.height
            anchors.rightMargin: -keyboardDisplay.width
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: (settings.height - keyboardDisplay.height)/2
            z:2
        }

        Rectangle{
            id:settingsButtons
            anchors.left: parent.left
            anchors.leftMargin: window1.width
            anchors.top: rectangle2.bottom
            anchors.topMargin: butTopMargin
            width:settings.buttonWidth+settingsDisplay.buttonWidth / 5
            z:15

            Button {
                id: calibBut
                width: settings.buttonWidth
                height:settings.buttonHeight
                text: qsTr("Калибровка")
                anchors.left: parent.left
                anchors.leftMargin: settingsDisplay.buttonWidth / 10
                anchors.top: parent.top
                anchors.topMargin: butTopMargin

                style: ButtonStyle {
                    label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family: helvetica.name
                        font.pointSize: buttonFontSize
                        color: window1.dayNight === false ? buttonNum === 1?  "black" :"#7fff00": "black"
                        text: control.text
                    }
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 25
                        border.width: control.pressed? 2 : 1
                        border.color: "#888"
                        radius: 4
                        color: buttonNum === 1 ? "#42e73a":dayNight === false ? "black" : "white"

                    }
                }
                onClicked:
                {
                    allAnimStop()
                    slideCompBack.start()
                    slideCompForward.start()
                    buttonNum = 1
                    compass.sound()
                }
            }

            Button {
                id: coefABut
                x: 6
                width: settings.buttonWidth
                height:settings.buttonHeight
                text: qsTr("Коэффициент A")
                anchors.top: deviBut.bottom
                anchors.topMargin: butTopMargin
                anchors.leftMargin: settingsDisplay.buttonWidth / 10
                anchors.left: parent.left
                style: ButtonStyle {
                    label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family: helvetica.name
                        font.pointSize: buttonFontSize
                        color: window1.dayNight === false ? buttonNum === 6?  "black" :"#7fff00": "black"
                        text: control.text
                    }
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 25
                        border.width: control.pressed? 2 : 1
                        border.color: "#888"
                        radius: 4
                        color: buttonNum === 6 ? "#42e73a":dayNight === false ? "black" : "white"

                    }
                }

                onClicked:
                {
                    keyboardDisplay.setMod(false)
                    keyboardDisplay.setRes(compass.getA())
                    keyboardDisplay.saved.disconnect(setSKL)
                    keyboardDisplay.saved.connect(setA)
                    allAnimStop()
                    slideCompBack.start()
                    allAnimStop()
                    slideKeybordForward.start()
                    buttonNum = 6
                    compass.sound()
                }
            }

            Button {
                id: deviBut
                width: settings.buttonWidth
                height:settings.buttonHeight
                text: qsTr("Калькулятор")
                anchors.top: calibBut.bottom
                anchors.topMargin: butTopMargin
                anchors.leftMargin: settingsDisplay.buttonWidth / 10
                anchors.left: parent.left
                style: ButtonStyle {
                    label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family: helvetica.name
                        font.pointSize: buttonFontSize
                        color: window1.dayNight === false ? buttonNum === 7?  "black" :"#7fff00": "black"
                        text: control.text
                    }
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 25
                        border.width: control.pressed? 2 : 1
                        border.color: "#888"
                        radius: 4
                        color: buttonNum === 7 ? "#42e73a":dayNight === false ? "black" : "white"

                    }
                }
                onClicked:
                {
                    deviationDisplay.deviationCourse = 0
                    allAnimStop()
                    slideCompBack.start()
                    slideDeviationForward.start()
                    buttonNum = 7
                    deviationDisplay.deviationButtonsStateReset();
                    compass.sound()
                }
            }

            Button {
                id: showmainButtonsBut

                width: settings.buttonWidth
                height:settings.buttonHeight
                text: qsTr("Настройки")
                anchors.top: revertBut.bottom
                anchors.topMargin: butTopMargin
                anchors.leftMargin: settingsDisplay.buttonWidth / 10

                anchors.left: parent.left
                style: ButtonStyle {
                    label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family: helvetica.name
                        font.pointSize: buttonFontSize
                        color: window1.dayNight === false ? "#7fff00" : "black"
                        text: control.text
                    }
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 25
                        border.width: control.pressed? 2 : 1
                        border.color: "#878787"
                        radius: 4
                        color: dayNight === false ? "black" : "white"
                    }
                }
                onClicked:
                {

                    allAnimStop()
                    slideCompBack.start()
                    butState = ~butState
                    showMainBut.start()
                    buttonNum = 0
                    compass.sound()
                }
            }
            Button {
                id: revertBut
                width: settings.buttonWidth
                height:settings.buttonHeight
                text: qsTr("Датчик")
                anchors.top: deviTableBut.bottom
                anchors.topMargin: butTopMargin
                anchors.leftMargin: settingsDisplay.buttonWidth / 10
                anchors.left: parent.left
                style: ButtonStyle {
                    label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family: helvetica.name
                        font.pointSize: buttonFontSize
                        color: window1.dayNight === false ? buttonNum === 9?  "black" :"#7fff00": "black"
                        text: control.text
                    }
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 25
                        border.width: control.pressed? 2 : 1
                        border.color: "#888"
                        radius: 4
                        color: buttonNum === 9 ? "#42e73a":dayNight === false ? "black" : "white"

                    }
                }
                onClicked:{
                    buttonNum = 9
                    compass.sound()
                    passDial.clearText()
                    allAnimStop()
                    slideCompBack.start()
                    slidePassDialForward.start()

                }
                    //compass.revert()
            }
            Button {
                id: deviTableBut

                width: settings.buttonWidth
                height:settings.buttonHeight
                text: qsTr("Таблица")
                anchors.top: coefABut.bottom
                anchors.topMargin: butTopMargin
                anchors.leftMargin: settingsDisplay.buttonWidth / 10

                anchors.left: parent.left
                style: ButtonStyle {
                    label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family: helvetica.name
                        font.pointSize: buttonFontSize
                        color: window1.dayNight === false ? buttonNum === 10?  "black" :"#7fff00": "black"
                        text: control.text
                    }
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 25
                        border.width: control.pressed? 2 : 1
                        border.color: "#888"
                        radius: 4
                        color: buttonNum === 10 ? "#42e73a":dayNight === false ? "black" : "white"

                    }
                }
                onClicked:{
                    buttonNum = 10
                    compass.sound()
                    passDial.clearText()
                    allAnimStop()
                    slideCompBack.start()
                    slideDeviTableForward.start()
                    deviTable.setDev()

                }
                    //compass.revert()
            }
        }


        Rectangle{
        id:mainButtons

        anchors.top: rectangle2.bottom
        anchors.topMargin: butTopMargin
        width:settings.buttonWidth+settingsDisplay.buttonWidth / 10
        anchors.left: parent.left
        anchors.leftMargin:0
        z:15

        Button
        {
            id: paramBut
            width: settings.buttonWidth
            height:settings.buttonHeight

            anchors.top: parent.top
            anchors.topMargin: butTopMargin
            anchors.leftMargin: settingsDisplay.buttonWidth / 10
            anchors.left: parent.left
            style: ButtonStyle {
                label: Text {
                    id:courseStateButText
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: helvetica.name
                    font.pointSize: buttonFontSize
                    color: window1.dayNight === false ? buttonNum === 12 ?  "black":"#7fff00" : "black"
                    text: "Параметры"
                }
                background: Rectangle{
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: control.pressed? 2 : 1
                    border.color: "#888"
                    radius: 4
                    color: buttonNum === 12 ? "#42e73a":dayNight === false ? "black" : "white"
                }
            }
            onClicked:{
                buttonNum = 12
                compass.sound()
                allAnimStop()
                slideCompBack.start()
                slideParamForward.start()
            }
        }

        Button {
            id: sklBut
            width: settings.buttonWidth
            height:settings.buttonHeight
            text: qsTr("Склонение")
            anchors.top: paramBut.bottom
            anchors.topMargin: butTopMargin
            anchors.leftMargin: settingsDisplay.buttonWidth / 10
            anchors.left: parent.left
            style: ButtonStyle {
                label: Text {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: helvetica.name
                    font.pointSize: buttonFontSize
                    color: window1.dayNight === false ? buttonNum === 3 ?  "black":"#7fff00" : "black"
                    text: control.text
                }
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: control.pressed? 2 : 1
                    border.color: "#888"
                    radius: 4
                    color: buttonNum === 3 ? "#42e73a":dayNight === false ? "black" : "white"
                }
            }

            onClicked:
            {
                keyboardDisplay.setMod(true)
                keyboardDisplay.setRes(compass.getSKL())
                keyboardDisplay.saved.disconnect(setA)
                keyboardDisplay.saved.connect(setSKL)
                allAnimStop()
                slideCompBack.start()
                slideKeybordForward.start()
                buttonNum = 3
                compass.sound()
            }
        }
        //        Button {
        //            id: degausBut
        //            width: settings.buttonWidth
        //            height:settings.buttonHeight
        //            text: qsTr("РУ")
        //            anchors.left: parent.left
        //            anchors.leftMargin: settingsDisplay.buttonWidth / 10
        //            anchors.top: sklBut.bottom
        //            anchors.topMargin: butTopMargin

        //            style: ButtonStyle {
        //                label: Text {
        //                    renderType: Text.NativeRendering
        //                    verticalAlignment: Text.AlignVCenter
        //                    horizontalAlignment: Text.AlignHCenter
        //                    font.family: helvetica.name
        //                    font.pointSize: buttonFontSize
        //                    color: window1.dayNight === false ? degaus===0 ? "#7fff00": "black" : "black"
        //                    text: control.text
        //                }
        //                background: Rectangle {
        //                    implicitWidth: 100
        //                    implicitHeight: 25
        //                    border.width: control.pressed? 2 : 1
        //                    border.color: "#888"
        //                    radius: 4
        //                    color: degaus === 1 ? "#42e73a":dayNight === false ? "black" : "white"
        //                }
        //            }
        //            onClicked:
        //            {
        //                degaus = !degaus
        //                deviTable.degaus = degaus
        //                deviTable.setDev()
        //                compass.setDegaus(degaus)
        //                compass.sound()
        //            }
        //        }

        Button {
            id: pitchRoll
            width: settings.buttonWidth
            height:settings.buttonHeight
            text: qsTr("Крен/Дифф")
            anchors.topMargin: butTopMargin
            anchors.top: sklBut.bottom
            anchors.leftMargin: settingsDisplay.buttonWidth / 10
            anchors.left: parent.left
            style: ButtonStyle {
                label: Text {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: helvetica.name
                    font.pointSize: buttonFontSize
                    color: window1.dayNight === false ? buttonNum === 4 ?  "black":"#7fff00" : "black"
                    text: control.text
                }
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: control.pressed? 2 : 1
                    border.color: "#888"
                    radius: 4
                    color: buttonNum === 4 ? "#42e73a":dayNight === false ? "black" : "white"

                }
            }
            onClicked:
            {
                allAnimStop()
                slideCompBack.start()
                slideMoreInfoForward.start()
                buttonNum = 4
                compass.sound()
            }
        }
        Button {
            id: magFieldBut
            width: settings.buttonWidth
            height:settings.buttonHeight
            text: qsTr("Поле")
            anchors.topMargin: butTopMargin
            anchors.top: pitchRoll.bottom
            anchors.leftMargin: settingsDisplay.buttonWidth / 10
            anchors.left: parent.left
            style: ButtonStyle {
                label: Text {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: helvetica.name
                    font.pointSize: buttonFontSize
                    color: window1.dayNight === false ? buttonNum === 11 ?  "black":"#7fff00" : "black"
                    text: control.text
                }
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: control.pressed? 2 : 1
                    border.color: "#888"
                    radius: 4
                    color: buttonNum === 11 ? "#42e73a":dayNight === false ? "black" : "white"

                }
            }
            onClicked:
            {
                allAnimStop()
                slideCompBack.start()
                slideMagFielForward.start()
                buttonNum = 11
                compass.sound()
            }
        }
        Button {
            id: deviDispBut
            width: settings.buttonWidth
            height:settings.buttonHeight
            text: qsTr("Девиация")
            anchors.top: magFieldBut.bottom
            anchors.topMargin: butTopMargin
            anchors.leftMargin: settingsDisplay.buttonWidth / 10

            anchors.left: parent.left
            style: ButtonStyle {
                label: Text {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: helvetica.name
                    font.pointSize: buttonFontSize
                    color: window1.dayNight === false ? buttonNum === 1 ?  "black":"#7fff00" : "black"
                    text: control.text
                }
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: control.pressed? 2 : 1
                    border.color: "#888"
                    radius: 4
                    color: buttonNum === 1 ? "#42e73a":dayNight === false ? "black" : "white"

                }
            }
            onClicked:
            {
                butState = ~butState
                allAnimStop()
                slideCompBack.start()
                showSettingsBut.start()
                buttonNum = 0
                compass.sound()
            }
        }


    }

        Rectangle {
            id: rectangle1
            width: 1
            color: dayNight === true?"#ffffff":"#42e73a"
            anchors.left: parent.right
            anchors.leftMargin: -settings.buttonWidth-settingsDisplay.buttonWidth / 5
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0

        }

        Rectangle {
            id: rectangle2
            height: 1
            color: dayNight === true?"#ffffff":"#42e73a"
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: lcdDisplay.height * 1.5
            z: 1
        }

    }
}
