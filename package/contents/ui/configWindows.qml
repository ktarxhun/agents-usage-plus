import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

// Which limit windows appear in the popup. Hidden ones are not drawn and do not
// count towards the tray icon.
KCM.SimpleKCM {
    property alias cfg_claudeSession: cb_claudeSession.checked
    property alias cfg_claudeWeekly: cb_claudeWeekly.checked
    property alias cfg_claudeScoped: cb_claudeScoped.checked
    property alias cfg_codexSession: cb_codexSession.checked
    property alias cfg_codexWeekly: cb_codexWeekly.checked
    property alias cfg_agGeminiSession: cb_agGeminiSession.checked
    property alias cfg_agGeminiWeekly: cb_agGeminiWeekly.checked
    property alias cfg_agClaudeSession: cb_agClaudeSession.checked
    property alias cfg_agClaudeWeekly: cb_agClaudeWeekly.checked
    property alias cfg_agArgonWeekly: cb_agArgonWeekly.checked

    Kirigami.FormLayout {
        QQC2.CheckBox {
            id: cb_claudeSession
            Kirigami.FormData.label: i18n("Claude Code:")
            text: i18n("5 hours")
        }

        QQC2.CheckBox {
            id: cb_claudeWeekly
            text: i18n("Weekly")
        }

        QQC2.CheckBox {
            id: cb_claudeScoped
            text: i18n("Weekly, per model (Opus, Sonnet)")
        }

        QQC2.CheckBox {
            id: cb_codexSession
            Kirigami.FormData.label: i18n("Codex:")
            text: i18n("5 hours")
        }

        QQC2.CheckBox {
            id: cb_codexWeekly
            text: i18n("Weekly")
        }

        QQC2.CheckBox {
            id: cb_agGeminiSession
            Kirigami.FormData.label: i18n("Antigravity, Gemini:")
            text: i18n("5 hours")
        }

        QQC2.CheckBox {
            id: cb_agGeminiWeekly
            text: i18n("Weekly")
        }

        QQC2.CheckBox {
            id: cb_agClaudeSession
            Kirigami.FormData.label: i18n("Antigravity, Claude and GPT:")
            text: i18n("5 hours")
        }

        QQC2.CheckBox {
            id: cb_agClaudeWeekly
            text: i18n("Weekly")
        }

        QQC2.CheckBox {
            id: cb_agArgonWeekly
            text: i18n("Gemini 4 Argon, weekly")
        }
    }
}
