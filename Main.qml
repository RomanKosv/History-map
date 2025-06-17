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

    ScrollView{
        id: mapSlot
        anchors.fill: parent

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

        Item{
            id: map
            property date current:"1025-01-01"
            anchors.fill: parent

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
                    required property string name
                    required property date start
                    required property date end
                    required property vector2d point
                    Rectangle{
                        id: townPoint
                        width: 20
                        height: width
                        radius: width/2
                        color: "red"
                        visible: start<=map.current && map.current<end
                        x: point.x
                        y: point.y
                        Component.onCompleted: {
                            console.log("Rect: ", x, y, visible)
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
