const { Box } = Widget;
import  PopupWindow from "../../utils/popupWindow.js";

export const DashboardWindow = (name, children) => PopupWindow({
    name: name,
    anchor: ["top","bottom", "right"],
    margins: [12, 12, 15],
    transition: "slide_left",
    transitionDuration: 150,
    child: Box({
        vertical:true,
        children: children
    }),
    setup: (self) => {
      self.on("button-press-event", () => App.toggleWindow(name));
    }
});
