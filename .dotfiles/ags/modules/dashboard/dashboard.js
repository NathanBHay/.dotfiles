import { VolumeSlider } from "./volumeSlider.js"
import { BrightnessSlider } from "./brightnessSlider.js"
import { Buttons } from "./buttons.js"
import { NotificationList } from "./notificationList.js";
import { DashboardWindow } from "./dashboardwindow.js";

export const Dashboard = () => DashboardWindow("dashboard", [
    Buttons(),
    VolumeSlider(),
    BrightnessSlider(),
    NotificationList(),
]);
