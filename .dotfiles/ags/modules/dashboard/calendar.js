import Gtk from 'gi://Gtk';
const { Box } = Widget;
import { DashboardWindow } from './dashboardwindow.js';

const CalendarWidget = () => Box({
    className: "calendar",
    vpack: 'end',
    vertical: true,
    children: [ 
        Widget.subclass(Gtk.Calendar)({
            showDayNames: true,
            showHeading: true,
            className: 'calendarWidget',
        })
    ]
})

export const Calendar = () => DashboardWindow("calendar", [CalendarWidget()]);
