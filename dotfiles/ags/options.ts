import { opt, mkOptions } from "lib/option"
import { distro } from "lib/variables"
import { icon } from "lib/utils"
import icons from "lib/icons"

const options = mkOptions(OPTIONS, {
    autotheme: opt(false),

    wallpaper: {
        resolution: opt<import("service/wallpaper").Resolution>(1920),
        market: opt<import("service/wallpaper").Market>("random"),
    },

    theme: {
        dark: {
            primary: {
                bg: opt("#cba6f7"),
                fg: opt("#1e1e2e"),
            },
            error: {
                bg: opt("#f38ba8"),
                fg: opt("#1e1e2e"),
            },
            bg: opt("#11111b"),
            fg: opt("#cdd6f4"),
            widget: opt("#cdd6f4"),
            border: opt("#cdd6f4"),
        },

        blur: opt(0),
        scheme: opt<"dark">("dark"),
        widget: { opacity: opt(94) },
        border: {
            width: opt(1),
            opacity: opt(96),
        },

        shadows: opt(true),
        padding: opt(7),
        spacing: opt(12),
        radius: opt(11),
    },

    transition: opt(200),

    font: {
        size: opt(10),
        name: opt("FiraMono Nerd Font"),
    },

    bar: {
        flatButtons: opt(true),
        position: opt<"top" | "bottom">("bottom"),
        corners: opt(50),
        transparent: opt(false),
        layout: {
            start: opt<Array<import("widget/bar/Bar").BarWidget>>([
                "launcher",
                "workspaces",
                "taskbar",
                "expander",
            ]),
            center: opt<Array<import("widget/bar/Bar").BarWidget>>([]),
            end: opt<Array<import("widget/bar/Bar").BarWidget>>([
                // "media",
                "expander",
                "systray",
                "screenrecord",
                "system",
                "date",
                "powermenu",
            ]),
        },
        launcher: {
            icon: {
                colored: opt(true),
                icon: opt(icon(distro.logo, icons.ui.search)),
            },
            action: opt(() => App.toggleWindow("launcher")),
        },
        date: {
            format: opt("%d %b %H:%M"),
            action: opt(() => App.toggleWindow("datemenu")),
        },
        battery: {
            charging: opt("#A6E3A1"),
            low: opt(20),
        },
        workspaces: {
            workspaces: opt(7),
        },
        taskbar: {
            iconSize: opt(0),
            monochrome: opt(true),
            exclusive: opt(false),
        },
        messages: {
            action: opt(() => App.toggleWindow("datemenu")),
        },
        systray: {
            ignore: opt([
                "KDE Connect Indicator",
                "spotify-client",
            ]),
        },
        media: {
            monochrome: opt(true),
            preferred: opt("spotify"),
            direction: opt<"left" | "right">("right"),
            format: opt("{artists} - {title}"),
            length: opt(40),
        },
        powermenu: {
            monochrome: opt(false),
            action: opt(() => App.toggleWindow("powermenu")),
        },
    },

    launcher: {
        width: opt(0),
        margin: opt(80),
        nix: {
            pkgs: opt("nixpkgs/nixos-unstable"),
            max: opt(6),
        },
        sh: {
            max: opt(16),
        },
        apps: {
            iconSize: opt(40),
            max: opt(6),
            favorites: opt([
                [
                    "brave",
                    "kitty",
                    "obsidian",
                    "vesktop",
                    "spotify",
                ],
            ]),
        },
    },

    overview: {
        scale: opt(9),
        workspaces: opt(7),
        monochromeIcon: opt(true),
    },

    powermenu: {
        sleep: opt("systemctl suspend-then-hibernate"),
        reboot: opt("systemctl reboot"),
        logout: opt("pkill Hyprland"),
        shutdown: opt("shutdown now"),
        layout: opt<"line" | "box">("line"),
        labels: opt(true),
    },

    quicksettings: {
        avatar: {
            image: opt(`~/Pictures/.avatar.jpg`),
            size: opt(70),
        },
        width: opt(380),
        position: opt<"left" | "center" | "right">("right"),
        networkSettings: opt("gtk-launch gnome-control-center"),
        media: {
            monochromeIcon: opt(true),
            coverSize: opt(100),
        },
    },

    datemenu: {
        position: opt<"left" | "center" | "right">("right"),
        weather: {
            interval: opt(60_000),
            unit: opt<"metric" | "imperial" | "standard">("metric"),
            key: opt<string>(
                JSON.parse(Utils.readFile(`${App.configDir}/.weather`) || "{}")?.key || "",
            ),
            cities: opt<Array<number>>(
                JSON.parse(Utils.readFile(`${App.configDir}/.weather`) || "{}")?.cities || [],
            ),
        },
    },

    osd: {
        progress: {
            vertical: opt(true),
            pack: {
                h: opt<"start" | "center" | "end">("end"),
                v: opt<"start" | "center" | "end">("center"),
            },
        },
        microphone: {
            pack: {
                h: opt<"start" | "center" | "end">("center"),
                v: opt<"start" | "center" | "end">("end"),
            },
        },
    },

    notifications: {
        position: opt<Array<"top" | "bottom" | "left" | "right">>(["bottom", "right"]),
        blacklist: opt(["Spotify"]),
        width: opt(440),
    },

    hyprland: {
        gaps: opt(2.4),
        inactiveBorder: opt("#282828"),
        gapsWhenOnly: opt(false),
    },
})

globalThis["options"] = options
export default options
