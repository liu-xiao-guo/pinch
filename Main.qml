import QtQuick 2.0
import Ubuntu.Components 1.1

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "pinch.ubuntu"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(50)
    height: units.gu(75)

    Page {
        id:main
        title: i18n.tr("Simple")

        Flickable {
            id: flick
            anchors.fill: parent
            contentWidth: 768
            contentHeight: 1024

            PinchArea {
                width: Math.max(flick.contentWidth, flick.width)
                height: Math.max(flick.contentHeight, flick.height)

                pinch.maximumScale: 20;
                pinch.minimumScale: 0.2;
                pinch.minimumRotation: 0;
                pinch.maximumRotation: 1;

                property real initialWidth
                property real initialHeight

                onPinchStarted: {
                    initialWidth = flick.contentWidth
                    initialHeight = flick.contentHeight
                }

                onPinchUpdated: {
                    // adjust content pos due to drag
                    flick.contentX += pinch.previousCenter.x - pinch.center.x
                    flick.contentY += pinch.previousCenter.y - pinch.center.y

                    console.log("rotation: " + pinch.rotation );
                    if ( pinch.rotation > 0 )
                        flick.rotation += 0.2;
                    else
                        flick.rotation -= 0.2;

                    // resize content
                    flick.resizeContent(initialWidth * pinch.scale, initialHeight * pinch.scale, pinch.center)
                }

                onPinchFinished: {
                    // Move its content within bounds.
                    flick.returnToBounds()
                }

                Rectangle {
                    width: flick.contentWidth
                    height: flick.contentHeight
                    color: "white"
                    Image {
                        id: image
                        anchors.fill: parent
                        source: "images/sky.jpg"
                        MouseArea {
                            anchors.fill: parent
                        }
                    }
                }
            }
        }
    }
}

