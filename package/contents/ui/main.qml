import QtQuick
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as P5Support

PlasmoidItem {
    id: root

    // Parsed output of fetch_usage.py: { fetchedAt, providers: [...] }
    property var usage: null
    property bool loading: false
    property string lastError: ""

    // Smallest remaining percentage across every window of every provider,
    // or -1 when nothing is known yet. Drives the tray icon.
    readonly property real worstRemaining: {
        if (!usage || !usage.providers)
            return -1;
        let worst = -1;
        for (const p of shownProviders) {
            for (const w of p.windows) {
                if (w.usedPercent === null)
                    continue;
                const left = 100 - w.usedPercent;
                if (worst < 0 || left < worst)
                    worst = left;
            }
        }
        return worst;
    }

    // Parsed output of token_stats.py: { generatedAt, scanning, daily, periods }
    property var tokens: null
    property bool tokensLoading: false
    property string tokensError: ""

    function scriptCommand(name, niced) {
        const path = Qt.resolvedUrl("../code/" + name).toString().replace(/^file:\/\//, "");
        // The token scan reads large log files, so it runs at idle priority.
        return (niced ? "nice -n 10 ionice -c 3 " : "") + "python3 -I '" + path.replace(/'/g, "'\\''") + "'";
    }
    readonly property string command: scriptCommand("fetch_usage.py", false)

    readonly property var cfg: Plasmoid.configuration

    // Whether a provider, or one of its windows, is chosen in the settings.
    // w is null when only the provider itself is asked about.
    function isShown(pid, w) {
        const providerFlag = ({ claude: cfg.showClaude, codex: cfg.showCodex, antigravity: cfg.showAntigravity })[pid];
        if (providerFlag === false)
            return false;
        if (!w)
            return true;
        const setting = windowSetting(pid, w);
        return setting ? cfg[setting] !== false : true;
    }

    // Name of the boolean setting that controls one window.
    function windowSetting(pid, w) {
        if (pid === "claude")
            return ({ session: "claudeSession", weekly: "claudeWeekly", weekly_scoped: "claudeScoped" })[w.key] ?? null;
        if (pid === "codex")
            return ({ session: "codexSession", weekly: "codexWeekly" })[w.key] ?? null;
        if (pid === "antigravity") {
            if (w.key === "weekly_scoped")
                return "agArgonWeekly";
            return (w.model === "Gemini" ? "agGemini" : "agClaude") + (w.key === "session" ? "Session" : "Weekly");
        }
        return null;
    }

    // Providers and windows the user kept switched on, in display order.
    readonly property var shownProviders: (usage && usage.providers ? usage.providers : []).filter(p => isShown(p.id, null)).map(p => {
        return Object.assign({}, p, { windows: (p.windows || []).filter(w => isShown(p.id, w)) });
    })
    readonly property string tokensCommand: scriptCommand("token_stats.py", true)

    function refreshTokens() {
        if (tokensLoading)
            return;
        tokensLoading = true;
        tokenSource.connectSource(tokensCommand);
    }

    P5Support.DataSource {
        id: tokenSource
        engine: "executable"
        connectedSources: []
        onNewData: (source, data) => {
            disconnectSource(source);
            root.tokensLoading = false;
            try {
                root.tokens = JSON.parse(data["stdout"]);
                root.tokensError = "";
            } catch (e) {
                root.tokensError = (data["stderr"] || "").trim() || i18n("The helper script returned invalid output");
            }
        }
    }

    function refresh() {
        if (loading)
            return;
        loading = true;
        executable.connectSource(command);
    }

    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: (source, data) => {
            disconnectSource(source);
            root.loading = false;
            try {
                root.usage = JSON.parse(data["stdout"]);
                root.lastError = "";
            } catch (e) {
                root.lastError = (data["stderr"] || "").trim() || i18n("The helper script returned invalid output");
            }
        }
    }

    Timer {
        interval: cfg.refreshMinutes * 60 * 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.refresh();
            root.refreshTokens();
        }
    }

    // Refresh whenever the popup opens so the numbers are current on click.
    onExpandedChanged: {
        if (expanded) {
            refresh();
            refreshTokens();
        }
    }

    Plasmoid.icon: "speedometer"
    toolTipMainText: i18n("Agents Usage")
    toolTipSubText: {
        if (!usage || !usage.providers)
            return loading ? i18n("Loading…") : lastError;
        return shownProviders.map(p => {
            const parts = p.windows.filter(w => w.usedPercent !== null && (w.key === "session" || w.key === "weekly"))
                .map(w => i18nc("tooltip, e.g. 5 hours: 76% left", "%1: %2% left", w.key === "session" ? i18n("5 hours") : i18n("Weekly"), Math.round(100 - w.usedPercent)));
            return p.name + ": " + (parts.length ? parts.join(", ") : (p.errorCode ? i18n("unavailable") : i18n("no data")));
        }).join("\n");
    }

    switchWidth: Kirigami.Units.gridUnit * 12
    switchHeight: Kirigami.Units.gridUnit * 12

    compactRepresentation: CompactRepresentation {}
    fullRepresentation: FullRepresentation {}
}
