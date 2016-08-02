import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {
    id:parentRect
    width: settings.width-buttonWidth - button1.anchors.leftMargin * 2
    height: window1.height
    color: "#00000000"
    property int butTopMargin:20
    property int butWidth: width /8
    property int butHeight: window1.height/12
    property int lableFontSize:butHeight/1.5
    Rectangle{
        width: parent.width/3 + butWidth
        height: butHeight*4+butTopMargin*3
    color: "#00000000"
    anchors.centerIn: parent


        Label{
            id: courseState
            width: parentRect.width / 3
            height: butHeight
            text:"Курс"
            font.pixelSize: lableFontSize
            color: window1.dayNight ===false ? "#7fff00":"black"
            font.family:helvetica.name
        }

        Button
              {
                  id: courseStateBut
                  width: butWidth
                  height:butHeight
                  anchors.top: courseState.top
                  anchors.topMargin: -5
                  anchors.leftMargin: 0
                  anchors.left: courseState.right
                  style: ButtonStyle {
                      background: Rectangle {
                          border.width: control.pressed ? 5:1
                          border.color: "#888"
                          radius: 4
                          color: dayNight === false ? "black" : "white"
                      }
                      label: Text {

                          id:courseStateButText
                          renderType: Text.NativeRendering
                          verticalAlignment: Text.AlignVCenter
                          horizontalAlignment: Text.AlignHCenter
                          font.family: helvetica.name
                          font.pointSize: buttonFontSize
                          color: window1.dayNight ===false ? "#7fff00":"black"
                          text: "MK"
                          Component.onCompleted: courseStateButText.text = Qt.binding(function(){
                              if(trueMagneticCourse === 0)
                                  return "KK";
                              else if(trueMagneticCourse === 1)
                                  return "MK";
                              else if(trueMagneticCourse === 2)
                                  return "ИК";
                          })
                      }
                  }
                  onClicked:{
                      compass.sound()
                      compass.changeTrueMagneticCourse()
                  }
              }
            Label{
                id: degausState
                width: parentRect.width / 3
                height: butHeight
                anchors.top: courseState.bottom
                anchors.topMargin: butTopMargin
                anchors.leftMargin: 0
                anchors.left: courseState.left
                text:"РУ"
                font.pixelSize: lableFontSize
                color: window1.dayNight ===false ? "#7fff00":"black"
                font.family:helvetica.name
            }
            Button {
                    id: degausBut
                    text: degaus === 1? "Вкл" : "Выкл"
                    width: butWidth
                    height: butHeight
                    anchors.top: courseState.bottom
                    anchors.topMargin: butTopMargin
                    anchors.leftMargin:0
                    anchors.left: degausState.right
                    style: ButtonStyle {

                        label: Text {
                            renderType: Text.NativeRendering
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.family: helvetica.name
                            font.pointSize: buttonFontSize
                            color: window1.dayNight ===false ? "#7fff00":"black"
                            text: control.text
                        }
                        background: Rectangle {
                            border.width: control.pressed ? 5:1
                            border.color: "#888"
                            radius: 4
                            color: dayNight === false ? "black" : "white"
                        }
                    }
                    onClicked:
                    {
                        degaus = !degaus
                        deviTable.degaus = degaus
                        compass.setDegaus(degaus)
                        compass.sound()
                    }
                }
            Label{
                id: dempfState
                width: parentRect.width / 3
                height: butHeight
                anchors.top: degausState.bottom
                anchors.topMargin: butTopMargin
                anchors.leftMargin: 0
                anchors.left: courseState.left
                text:"Демпф."
                font.pixelSize: lableFontSize
                color: window1.dayNight ===false ? "#7fff00":"black"
                font.family:helvetica.name
            }
            Button
                    {
                        id: dempfButton
                        width: butWidth
                        height: butHeight
                        text: m_dempf === 0 ? "Выкл":"Вкл"
                        anchors.top: dempfState.top
                        anchors.topMargin: -5
                        anchors.left: dempfState.right
                        anchors.leftMargin: 0
                        style: ButtonStyle {
                            label: Text {
                                renderType: Text.NativeRendering
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.family: helvetica.name
                                font.pointSize: buttonFontSize
                                color: window1.dayNight ===false ? "#7fff00":"black"
                                text: control.text
                            }
                            background: Rectangle {
                                border.width: control.pressed ? 5:1
                                border.color: "#888"
                                radius: 4
                                color: dayNight === false ? "black" : "white"
                            }
                        }
                        onClicked:{
                            compass.sound()
                            compass.changeDempf();
                        }

                    }
            Label{
                id: dispState
                width: parentRect.width / 3
                height: butHeight
                anchors.top: dempfState.bottom
                anchors.topMargin: butTopMargin
                anchors.leftMargin: 0
                anchors.left: courseState.left
                text:"Экран"
                font.pixelSize: lableFontSize
                color: window1.dayNight ===false ? "#7fff00":"black"
                font.family:helvetica.name
            }

            Button {
                       id: dayNightButton
                       width: butWidth
                       height: butHeight
                       text: qsTr("День")
                       anchors.left: dispState.right
                       anchors.top: dispState.top
                       anchors.topMargin: -5
                       anchors.leftMargin: 0
                       style: ButtonStyle {
                           background: Rectangle {
                               border.width: control.pressed ? 5:1
                               border.color: "#888"
                               radius: 4
                               color: dayNight === false ? "black" : "white"
                           }
                           label: Text {
                               renderType: Text.NativeRendering
                               verticalAlignment: Text.AlignVCenter
                               horizontalAlignment: Text.AlignHCenter
                               font.family: helvetica.name
                               font.pointSize: buttonFontSize
                               color: window1.dayNight ===false ? "#7fff00":"black"
                               text: control.text
                           }
                       }
                       onClicked: {
                           compass.sound()
                           dayNight = !dayNight
                           dayNight === true ? sourseCompass10 = "content/compass10day.png" : sourseCompass10 = "content/compass10night.png"
                           dayNight === true ? sourseCompass360 = "content/compass360day.png" : sourseCompass360 = "content/compass360night.png"
                           dayNight === true ? sourceBackground = "content/backgroundDay.png" : sourceBackground = "content/backgroundNight.png"
                           dayNight === true ? dayNightButton.text = "День" : dayNightButton.text = "Ночь"

                       }
                   }
    }

}
