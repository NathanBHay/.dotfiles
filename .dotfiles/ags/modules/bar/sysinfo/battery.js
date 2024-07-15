const Battery = await Service.import("battery");
const { Box } = Widget;

const icons = [
    ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
    ["󰢟", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"],
];

export const BatteryWidget = () => Box({
    className: "battery",
    children: [
        Widget.Label({
            className: "batIcon",
            hexpand: true,
            setup: (self) => {
                self.hook(Battery, (self) => {
                    self.label =
                    icons[Battery.charging ? 1 : 0][
                        Math.floor(Battery.percent / 10)
                    ].toString();

                    if (Battery.percent <= 15 && Battery.charging === false) {
                        self.toggleClassName("low", true);
                    } else {
                        self.toggleClassName("low", false);
                    }
                });
            },
        }),
    ],
});
