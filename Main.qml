import QtQuick
import QtQuick.Controls
import HistoryMap

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    Database{
        id: database
        file: ":/database.tsv"
    }

    Shortcut{
        sequence: "Ctrl+H"
        onActivated: {
            mapSlot.focusX = map.width / 2
            mapSlot.focusY = map.height / 2
            mapSlot.mapScale = 1
        }
    }

    Item{
        id: timeScale
        height: 25
        anchors{
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        Slider{
            id: slider
            anchors{
                left: parent.left
                right: dateText.left
                top: parent.top
                bottom: parent.bottom
            }
            from: 0
            to: 1
        }
        Text{
            id: dateText
            width: 70
            anchors{
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            text: Qt.formatDate(map.current, "dd.MM.yyyy")
        }
    }

    Item{
        id: mapSlot
        anchors{
            top: parent.top
            right: parent.right
            left: parent.left
            bottom: timeScale.top
        }
        clip: true

        property double focusX: map.width / 2
        property double focusY: map.height / 2
        property double mapScale: 1

        MouseArea{
            anchors.fill: parent
            property double oldX: 0
            property double oldY: 0
            property bool drags: false
            property double maxScale: 50
            property double minScale: 0.5
            onPressed: (event) => {
                           drags = true
                           oldX = event.x
                           oldY = event.y
                       }
            onReleased: (event) => {
                            drags = false
                        }

            onPositionChanged: (event) => {
                                   if (drags) {
                                       console.log("old:", oldX, oldY, "new:", event.x, event.y)
                                       mapSlot.focusX = Math.min(Math.max(mapSlot.focusX + (oldX - event.x) / mapSlot.mapScale, 0), map.width)
                                       mapSlot.focusY = Math.min(Math.max(mapSlot.focusY + (oldY - event.y) / mapSlot.mapScale, 0), map.height)
                                       oldX = event.x
                                       oldY = event.y
                                       console.log("focus: ", mapSlot.focusX, mapSlot.focusY)
                                   }
                               }
            onWheel: (event) => {
                         mapSlot.mapScale = Math.max(Math.min(mapSlot.mapScale* (1.2 ** (event.angleDelta.y / 45.0)), maxScale), minScale)
                         console.log("scale: ", mapSlot.mapScale, "delta:", 1.2 ** (event.angleDelta.y / 45.0))
                     }
        }

        Image{
            id: map
            // property vector2d point1: Qt.vector2d(62, 51)
            // property vector2d point2: Qt.vector2d(56, 60)
            property vector2d point1: Qt.vector2d(61.668797, 50.836497)
            property vector2d point2: Qt.vector2d(56.093886, 59.943267)
            property date firstDate: "1300-01-01"
            property date lastDate: "2025-01-01"
            property date current: new Date(slider.value*lastDate.getTime() + (1 - slider.value)* firstDate.getTime())
            source: "qrc:/qt/qml/HistoryMap/map1.png"

            transform: [
                Translate{
                    x: map.width/2 - mapSlot.focusX
                    y: map.height/2 - mapSlot.focusY
                },
                Scale{
                    origin.x: map.width/2
                    origin.y: map.height/2
                    xScale: mapSlot.mapScale
                    yScale: mapSlot.mapScale
                }
            ]

            Repeater{
                id: towns
                model: database.towns
                Component.onCompleted: {
                    console.log("Towns: ", database.towns.length)
                }
                anchors.fill: parent

                delegate:Item{
                    id: town
                    visible: database.towns[index].alive(map.current)
                    required property string name
                    required property date start
                    required property date end
                    required property vector2d point
                    required property int index
                    y: (point.x - map.point1.x) * map.height / (map.point2.x - map.point1.x)
                    x: (point.y - map.point1.y) * map.width / (map.point2.y - map.point1.y)
                    onVisibleChanged: {
                        console.log(visible, x, y, name)
                        console.log("image:", map.width, map.height)
                    }

                    Rectangle{
                        id: townPoint
                        width: 10
                        height: width
                        radius: width/2
                        color: "red"
                        x: -width/2
                        y: -width/2 + 10
                        Component.onCompleted: {
                            console.log("Rect: ", point.x, point.y)
                        }
                    }
                    Text{
                        id: townName
                        x: townPoint.x
                        y: townPoint.y + townPoint.width
                        text: name
                    }
                }
            }
        }
    }
}
