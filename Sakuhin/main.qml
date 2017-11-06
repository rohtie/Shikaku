import QtQuick 2.7
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import sakuhin.backend 1.0
import sakuhin.shadermanager 1.0
import Qt.labs.folderlistmodel 2.2
import QtGraphicalEffects 1.0

import "qml"

ApplicationWindow {
    id: root
    flags: Qt.FramelessWindowHint
    visible: true
    width: 256
    height: 494
    color: "#111117"
    title: "Sakuhin"

    BackEnd {
        id: backend
    }

    ShaderManager {
        id: shadermanager
    }

    Component.onCompleted: backend.createSession();


    Column {
        id: column
        anchors.topMargin: 10
        clip: false
        anchors.bottomMargin: 30
        spacing: 10
        anchors.fill: parent

        Label {
            id: shaders_label
            height: 15
            color: "#dddddd"
            text: "Shaders"
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            font.pointSize: 8
            font.family: "Tahoma"
            anchors.right: parent.right

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    shader_view.visible = !shader_view.visible
                    shaders_icon.text = shader_view.visible ? '-' : '+'
                }
            }

            Label {
                id: shaders_icon
                x: 0
                y: 0
                height: 15
                color: "#dddddd"
                text: '-'
                horizontalAlignment: Text.AlignRight
                anchors.rightMargin: 0
                font.pointSize: 8
                anchors.left: parent.left
                anchors.right: parent.right
                font.family: "Tahoma"
                anchors.leftMargin: 0
            }
        }

        GridView {
            id: shader_view
            height: 60
            clip: true
            maximumFlickVelocity: 3000
            flickDeceleration: 1500
            boundsBehavior: Flickable.StopAtBounds
            snapMode: GridView.NoSnap
            cellHeight: 48
            cellWidth: 48

            anchors.left: parent.left
            anchors.leftMargin: 10

            anchors.right: parent.right
            anchors.rightMargin: 2.5

            model: shadermanager.shaders

            delegate: Item {
                width: shader_view.cellWidth
                height: shader_view.cellHeight

                Image {
                    id: shaderImage
                    anchors.fill: parent
                    anchors.topMargin: 0
                    anchors.rightMargin: 5
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 5

                    fillMode: Image.PreserveAspectCrop
                    source: model.modelData.thumbnail

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Item {
                            width: shaderImage.width
                            height: shaderImage.height

                            Rectangle {
                                anchors.fill: parent
                                radius: 2
                            }
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton

                onClicked: {
                    shaderContextmenu.x = parent.x + mouse.x
                    shaderContextmenu.y = parent.y + mouse.y

                    shaderContextmenu.open()
                }
            }
        }

        Label {
            id: transitions_label
            height: 15
            color: "#dddddd"
            text: "Transitions"
            font.family: "Tahoma"
            anchors.rightMargin: 10
            font.pointSize: 8
            anchors.leftMargin: 10
            MouseArea {
                anchors.fill: parent
            }

            Label {
                id: shaders_icon1
                x: 0
                y: 0
                height: 15
                color: "#dddddd"
                text: "-"
                font.family: "Tahoma"
                anchors.rightMargin: 0
                font.pointSize: 8
                anchors.leftMargin: 0
                horizontalAlignment: Text.AlignRight
                anchors.left: parent.left
                anchors.right: parent.right
            }
            anchors.left: parent.left
            anchors.right: parent.right
        }

        GridView {
            id: transition_view
            height: 60
            clip: true
            maximumFlickVelocity: 3000
            flickDeceleration: 1500
            boundsBehavior: Flickable.StopAtBounds
            snapMode: GridView.NoSnap
            cellHeight: 48
            cellWidth: 48

            anchors.left: parent.left
            anchors.leftMargin: 10

            anchors.right: parent.right
            anchors.rightMargin: 2.5

            model: shadermanager.transitionShaders

            delegate: Item {
                width: transition_view.cellWidth
                height: transition_view.cellHeight

                Image {
                    id: transitionImage
                    anchors.fill: parent
                    anchors.topMargin: 0
                    anchors.rightMargin: 5
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 5

                    fillMode: Image.PreserveAspectCrop
                    source: model.modelData.thumbnail

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Item {
                            width: transitionImage.width
                            height: transitionImage.height

                            Rectangle {
                                anchors.fill: parent
                                radius: 2
                            }
                        }
                    }
                }
            }
        }

        Label {
            id: channels_label
            height: 15
            color: "#dddddd"
            text: 'Channels'
            font.pointSize: 8
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            font.family: "Tahoma"
            anchors.right: parent.right

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    channels.visible = !channels.visible
                    channels_icon.text = channels.visible ? '-' : '+'
                }
            }

            Label {
                id: channels_icon
                x: 0
                y: 0
                height: 15
                color: "#dddddd"
                text: '-'
                horizontalAlignment: Text.AlignRight
                anchors.rightMargin: 0
                font.pointSize: 8
                anchors.left: parent.left
                anchors.right: parent.right
                font.family: "Tahoma"
                anchors.leftMargin: 0
            }
        }

        Flow {
            id: channels
            height: 48
            clip: true
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            spacing: 5

            Repeater {
                id: channelRepeater
                model: 6

                ChannelForm {
                    channel.onClicked: channelPopup.activate(index)
                }
            }
        }

        Label {
            id: controller_label
            height: 15
            color: "#dddddd"
            text: "Controllers"
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            font.pointSize: 8
            font.family: "Tahoma"
            anchors.right: parent.right

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    controller.visible = !controller.visible
                    controller_icon.text = controller.visible ? '-' : '+'
                }
            }

            Label {
                id: controller_icon
                x: 0
                y: 0
                height: 15
                color: "#dddddd"
                text: '-'
                horizontalAlignment: Text.AlignRight
                anchors.rightMargin: 0
                font.pointSize: 8
                anchors.left: parent.left
                anchors.right: parent.right
                font.family: "Tahoma"
                anchors.leftMargin: 0
            }
        }

        RowLayout {
            id: controller
            spacing: 0
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10

            Repeater {
                model: 4

                SliderControllerForm {
                    onValueChanged: backend.setSlider(index, value)
                }
            }
        }


    }

    Image {
        id: spectrum
        x: 10
        y: 225
        height: 35
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        fillMode: Image.PreserveAspectCrop
        source: "tmp/spectrum.jpg"

        Label {
            id: info
            x: 10
            y: 0
            height: 15
            color: "#dddddd"
            text: backend.performanceInformation
            horizontalAlignment: Text.AlignRight
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottomMargin: 10
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            font.family: "Tahoma"
            font.pointSize: 8
        }
    }


    Menu {
        id: shaderContextmenu
        title: "New shader"

        background: Rectangle {
            implicitWidth: 133
            implicitHeight: 10
            color: "#111117"
        }

        StyledMenuItem {
            text: "Minimal"
            onTriggered: console.log("Add minimal shader")
        }
        StyledMenuItem {
            text: "Feedback"
        }
        StyledMenuItem {
            text: "Raymarch"
        }
    }

    Popup {
        id: channelPopup
        x: 0
        y: 0
        width: parent.width
        height: parent.height
        visible: false
        rightPadding: 0
        leftPadding: 0
        bottomPadding: 0
        topPadding: 0
        spacing: 0
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape

        property int currentChannelID: 0

        function activate(channelID) {
            currentChannelID = channelID
            channelPopup.open()
        }

        background: Rectangle {
            color: "#111117"
        }

        Rectangle {
            id: bg
            width: parent.width
            height: parent.height
            color: "#111117"
        }

        Column {
            spacing: 0
            anchors.fill: parent

            StackLayout {
                width: parent.width
                height: parent.height - bar.height
                visible: true
                currentIndex: bar.currentIndex

                Item {
                    id: hardwareTab

                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "#ff0000"
                    }
                }
                Item {
                    id: textureTab

                    GridView {
                        id: textureGrid
                        clip: true
                        maximumFlickVelocity: 3000
                        flickDeceleration: 1500
                        boundsBehavior: Flickable.StopAtBounds
                        snapMode: GridView.NoSnap
                        cellHeight: 124
                        cellWidth: 124

                        anchors.rightMargin: 5
                        anchors.leftMargin: 5
                        anchors.bottomMargin: 10
                        anchors.topMargin: 10
                        anchors.fill: parent

                        model: FolderListModel {
                            folder: "file:data/textures/"
                        }

                        delegate: Item {
                            width: textureGrid.cellWidth
                            height: textureGrid.cellHeight

                            Image {
                                anchors.fill: parent
                                anchors.topMargin: 0
                                anchors.rightMargin: 5
                                anchors.leftMargin: 5
                                anchors.bottomMargin: 10

                                fillMode: Image.PreserveAspectFit
                                source: fileURL

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        var channelID = channelPopup.currentChannelID

                                        backend.setChannel(channelID, BackEnd.Texture, filePath)
                                        channelRepeater.itemAt(channelID).channelImage.source = fileURL
                                        channelPopup.close()
                                    }
                                }
                            }
                        }
                    }
                }
                Item {
                    id: shaderTab

                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "#0000ff"
                    }
                }
            }

            TabBar {
                id: bar
                height: 40
                currentIndex: 1
                spacing: 1
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0

                background: Rectangle {
                    color: "#111117"
                }

                TabForm {
                    text: qsTr("Hardware")
                }
                TabForm {
                    text: qsTr("Textures")
                }
                TabForm {
                    text: qsTr("Shaders")
                }
            }

        }

    }

}
