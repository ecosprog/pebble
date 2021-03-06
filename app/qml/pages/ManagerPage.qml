import QtQuick 2.0
import QtQml 2.1
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0
import org.nemomobile.dbus 2.0

Page {
    id: page

    ConfigurationGroup {
        id: settings
        path: "/org/pebbled/settings"
        property string profileWhenConnected: ""
        property string profileWhenDisconnected: ""
        property bool transliterateMessage
        property bool useSystemVolume
        property bool incomingCallNotification
        property bool notificationsCommhistoryd
        property bool notificationsMissedCall
        property bool notificationsEmails
        property bool notificationsMitakuuluu
        property bool notificationsTwitter
        property bool notificationsFacebook
        property bool notificationsOther
        property bool notificationsAll
    }

    DBusInterface {
        id: profiled

        service: 'com.nokia.profiled'
        iface: 'com.nokia.profiled'
        path: '/com/nokia/profiled'

        property var profiles
    }

    Component.onCompleted: {
        profiled.typedCall('get_profiles', [], function (result) {
            console.log('Got profiles: ' + result);
            profiled.profiles = result;
        });
    }



    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator { flickable: flickable }

        PullDownMenu {
            MenuItem {
                text: qsTr("Pebble Appstore")
                onClicked: pageStack.push(Qt.resolvedUrl("AppStorePage.qml"))
            }
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Pebble Manager")
            }

            Label {
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                visible: pebbled.active && !pebbled.connected
                text: qsTr("Waiting for watch...\nIf it can't be found please check it's available and paired in Bluetooth settings.")
                wrapMode: Text.Wrap
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }

            }
            Button {
                visible: pebbled.connected
                text: pebbled.name
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                onClicked: pageStack.push(Qt.resolvedUrl("WatchPage.qml"))
            }

            Label {
                text: qsTr("Service")
                font.family: Theme.fontFamilyHeading
                color: Theme.highlightColor
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
            }
            TextSwitch {
                text: qsTr("Enabled")
                description: pebbled.enabled ? qsTr("Automatic startup") : qsTr("Manual startup")
                checked: pebbled.enabled
                automaticCheck: false
                onClicked: pebbled.setEnabled(!checked)
            }
            TextSwitch {
                text: qsTr("Active")
                description: pebbled.active ? qsTr("Running") : qsTr("Dead")
                checked: pebbled.active
                automaticCheck: false
                onClicked: pebbled.setActive(!checked)
            }
            TextSwitch {
                text: qsTr("Connection")
                description: pebbled.connected ? qsTr("Connected"): qsTr("Disconnected")
                checked: pebbled.connected
                automaticCheck: false
                onClicked: {
                    if (pebbled.connected) {
                        pebbled.disconnect();
                    } else {
                        pebbled.reconnect();
                    }
                }
            }

            Label {
                text: qsTr("Settings")
                font.family: Theme.fontFamilyHeading
                color: Theme.highlightColor
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
            }
            TextSwitch {
                text: qsTr("Forward phone calls")
                checked: settings.incomingCallNotification
                automaticCheck: false
                onClicked: {
                    settings.incomingCallNotification = !settings.incomingCallNotification;
                }
            }
            TextSwitch {
                text: qsTr("Control main volume")
                description: qsTr("Pebble music volume buttons change the main phone volume directly instead of through the music player.")
                checked: settings.useSystemVolume
                automaticCheck: true
                onClicked: {
                    settings.useSystemVolume = !settings.useSystemVolume;
                }
            }
            TextSwitch {
                text: qsTr("Transliterate messages")
                description: qsTr("Messages are transliterated to ASCII before sending to Pebble")
                checked: settings.transliterateMessage
                automaticCheck: false
                onClicked: {
                    settings.transliterateMessage = !settings.transliterateMessage;
                }
            }

            Label {
                text: qsTr("Notifications")
                font.family: Theme.fontFamilyHeading
                color: Theme.highlightColor
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
            }

            TextSwitch {
                text: qsTr("Messaging")
                description: qsTr("SMS and IM")
                checked: settings.notificationsCommhistoryd
                automaticCheck: false
                onClicked: {
                    settings.notificationsCommhistoryd = !settings.notificationsCommhistoryd;
                }
            }

            TextSwitch {
                text: qsTr("Missed call")
                checked: settings.notificationsMissedCall
                automaticCheck: false
                onClicked: {
                    settings.notificationsMissedCall = !settings.notificationsMissedCall;
                }
            }

            TextSwitch {
                text: qsTr("Emails")
                checked: settings.notificationsEmails
                automaticCheck: false
                onClicked: {
                    settings.notificationsEmails = !settings.notificationsEmails;
                }
            }

            TextSwitch {
                text: qsTr("Mitakuuluu")
                checked: settings.notificationsMitakuuluu
                automaticCheck: false
                onClicked: {
                    settings.notificationsMitakuuluu = !settings.notificationsMitakuuluu;
                }
            }

            TextSwitch {
                text: qsTr("Twitter")
                checked: settings.notificationsTwitter
                automaticCheck: false
                onClicked: {
                    settings.notificationsTwitter = !settings.notificationsTwitter;
                }
            }

            TextSwitch {
                visible: false //not yet supported
                text: qsTr("Facebook")
                checked: settings.notificationsFacebook
                automaticCheck: false
                onClicked: {
                    settings.notificationsFacebook = !settings.notificationsFacebook;
                }
            }

            TextSwitch {
                text: qsTr("Other notifications")
                checked: settings.notificationsOther
                automaticCheck: false
                onClicked: {
                    settings.notificationsOther = !settings.notificationsOther;
                }
            }

            TextSwitch {
                text: qsTr("All notifications")
                checked: settings.notificationsAll
                automaticCheck: false
                enabled: settings.notificationsOther
                onClicked: {
                    settings.notificationsAll = !settings.notificationsAll;
                }
            }

            Label {
                text: qsTr("Profiles")
                font.family: Theme.fontFamilyHeading
                color: Theme.highlightColor
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
            }

            ComboBox {
                label: qsTr("Connected")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("no change")
                        font.capitalization: Font.SmallCaps
                    }
                    Repeater {
                        model: profiled.profiles
                        delegate: MenuItem {
                            text: modelData
                            down: modelData === settings.profileWhenConnected
                        }
                    }
                }
                value: settings.profileWhenConnected || qsTr("no change")
                onCurrentIndexChanged: {
                    settings.profileWhenConnected = currentIndex ? currentItem.text : ""
                }
            }

            ComboBox {
                label: qsTr("Disconnected")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("no change")
                        font.capitalization: Font.SmallCaps
                    }
                    Repeater {
                        model: profiled.profiles
                        delegate: MenuItem {
                            text: modelData
                            down: modelData === settings.profileWhenDisconnected
                        }
                    }
                }
                value: settings.profileWhenDisconnected || qsTr("no change")
                onCurrentIndexChanged: {
                    settings.profileWhenDisconnected = currentIndex ? currentItem.text : ""
                }
            }
        }
    }
}
