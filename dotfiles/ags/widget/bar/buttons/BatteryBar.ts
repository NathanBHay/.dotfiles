import icons from "lib/icons"
import options from "options"

const battery = await Service.import("battery")
const { percentage, low } = options.bar.battery

export default () => Widget.Box({
    class_name: "battery-bar",
    visible: battery.bind("available"),
    child: Widget.Icon().hook(battery, self => {
            self.icon = battery.charging || battery.charged
                ? icons.battery.charging
                : battery.icon_name
    }),
    setup: self => self
        .hook(battery, w => {
            w.toggleClassName("charging", battery.charging || battery.charged)
            w.toggleClassName("low", battery.percent < low.value)
        }),
})
