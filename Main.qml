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

    ScrollView{
        id: mapSlot
        anchors.fill: parent
        Item{
            id: map
            property date current:"1025-01-01"
            anchors.fill: parent
            Repeater{
                id: towns
                model: database.towns
                Component.onCompleted: {
                    console.log("Towns: ", database.towns.length)
                }
                anchors.fill: parent

                delegate: Rectangle{
                    id: town
                    required property date start
                    required property date end
                    required property vector2d point
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
            }
        }
    }
}
