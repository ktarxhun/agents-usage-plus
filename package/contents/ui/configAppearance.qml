import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
    property alias cfg_showTokensTab: showTokensTab.checked
    property alias cfg_showLastUpdated: showLastUpdated.checked
    property string cfg_trayStyle: "ring"

    Kirigami.FormLayout {
        QQC2.ComboBox {
            id: trayStyle
            Kirigami.FormData.label: i18n("Tray icon:")
            model: [i18n("Ring with the lowest remaining %"), i18n("Plain icon")]
            currentIndex: cfg_trayStyle === "icon" ? 1 : 0
            onActivated: cfg_trayStyle = currentIndex === 1 ? "icon" : "ring"
        }

        QQC2.CheckBox {
            id: showTokensTab
            Kirigami.FormData.label: i18n("Popup:")
            text: i18n("Show the Tokens tab")
        }

        QQC2.CheckBox {
            id: showLastUpdated
            text: i18n("Show the last update time")
        }
    }
}
