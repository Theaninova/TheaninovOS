import Widget from "resource:///com/github/Aylur/ags/widget.js"
import SystemTray from "resource:///com/github/Aylur/ags/service/systemtray.js"
import Gdk from "gi://Gdk?version=3.0"

const REVEAL_DURATION = 200

/**
 * @param item {import('resource:///com/github/Aylur/ags/service/systemtray.js').TrayItem}
 */
function SysTrayItem(item) {
  return Widget.Button({
    class_name: "bar-systray-item",
    child: Widget.Icon({
      halign: "center",
      size: 16,
      binds: [["icon", item, "icon"]],
    }),
    binds: [["tooltip-markup", item, "tooltip-markup"]],
    on_clicked(button) {
      return item.menu.popup_at_widget(button, Gdk.Gravity.SOUTH, Gdk.Gravity.NORTH, null)
    },
    on_secondary_click(button) {
      return item.menu.popup_at_widget(button, Gdk.Gravity.SOUTH, Gdk.Gravity.NORTH, null)
    },
  })
}

/**
 * @param [props] {Parameters<typeof Widget.Box>[0]}
 */
function Tray(props = {}) {
  return Widget.Box({
    ...props,
    children: [
      Widget.Revealer({
        reveal_child: false,
        transition: "slide_left",
        transition_duration: REVEAL_DURATION,
        child: Widget.Box({
          vpack: "center",
          class_name: "bar-systray bar-group",
          binds: [["children", SystemTray, "items", i => i.map(SysTrayItem)]],
        }),
      }),
    ],
  })
}

export default Tray
