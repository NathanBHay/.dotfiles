import { ArrowToggleButton, Menu } from "../ToggleButton"
import icons from "lib/icons"

import asusctl from "service/asusctl"
const asusprof = asusctl.bind("profile")

const AsusProfileToggle = () => ArrowToggleButton({
    name: "asusctl-profile",
    icon: asusprof.as(p => icons.asusctl.profile[p]),
    label: asusprof,
    connection: [asusctl, () => asusctl.profile !== "Balanced"],
    activate: () => asusctl.setProfile("Quiet"),
    deactivate: () => asusctl.setProfile("Balanced"),
    activateOnArrow: false,
})

const AsusProfileSelector = () => Menu({
    name: "asusctl-profile",
    icon: asusprof.as(p => icons.asusctl.profile[p]),
    title: "Profile Selector",
    content: [
        Widget.Box({
            vertical: true,
            hexpand: true,
            children: [
                Widget.Box({
                    vertical: true,
                    children: asusctl.profiles.map(prof => Widget.Button({
                        on_clicked: () => asusctl.setProfile(prof),
                        child: Widget.Box({
                            children: [
                                Widget.Icon(icons.asusctl.profile[prof]),
                                Widget.Label(prof),
                            ],
                        }),
                    })),
                }),
            ],
        }),
        Widget.Separator(),
        Widget.Button({
            on_clicked: () => Utils.execAsync("rog-control-center"),
            child: Widget.Box({
                children: [
                    Widget.Icon(icons.ui.settings),
                    Widget.Label("Rog Control Center"),
                ],
            }),
        }),
    ],
})
