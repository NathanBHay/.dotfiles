// import { Utils, Widget, Hyprland } from "../../imports.js";
const Hyprland = await Service.import("hyprland");
const { execAsync } = Utils;
const { Box } = Widget;

// Find workspace class
const workspaceClass = (btn, id) => btn.attribute.index === Hyprland.active.workspace.id
    ? "focused"
    : (Hyprland.getWorkspace(id + 1)?.windows || 0) === 0
    ? "empty"
    : "";

// Workspace buttons
export const Workspaces = () => Box({
    className:"workspaces_pill",
    child:Box({
        className: "workspaces",
        child: Box({
            children: Array.from({ length: 6 }, (_, i) => i + 1).map((i) =>
                Widget.Button({
                    cursor: "pointer",
                    attribute: { index: i },
                    onClicked: () =>
                        execAsync([
                            "hyprctl",
                            "dispatch",
                            "workspace",
                             `${i}`
                        ]).catch(console.error),
                    onSecondaryClick: () =>
                        execAsync([
                            "hyprctl",
                            "dispatch",
                            "movetoworkspacesilent",
                            `${i}`,
                        ]).catch(console.error),
                }),
            ),
            setup: (self) => {
                self.hook(Hyprland, (self) =>
                    self.children.forEach((btn, i) => {
                        btn.className = workspaceClass(btn, i);
                    }),
                );
            },
        }),
    }),
});
