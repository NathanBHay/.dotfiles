import { clock } from "lib/variables"
import options from "options"
import icons from "lib/icons"
import BatteryBar from "widget/bar/buttons/BatteryBar"
import PanelButton from "widget/bar/PanelButton"

const { scheme } = options.theme
const { monochrome } = options.bar.powermenu
const { format } = options.bar.date

const poweroff = PanelButton({
    class_name: "powermenu",
    child: Widget.Icon(icons.powermenu.shutdown),
    on_clicked: () => Utils.exec("shutdown now"),
    setup: self => self.hook(monochrome, () => {
        self.toggleClassName("colored", !monochrome.value)
        self.toggleClassName("box")
    }),
})

const date = PanelButton({
    class_name: "date",
    child: Widget.Label({
        label: clock.bind().as(c => c.format(`${format}`)!),
    }),
})

export default Widget.CenterBox({
    class_name: "bar",
    hexpand: true,
    center_widget: date,
    end_widget: Widget.Box({
        hpack: "end",
        children: [
            BatteryBar(),
            poweroff,
        ],
    }),
})
