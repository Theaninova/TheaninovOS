import {lookUpIcon} from "resource:///com/github/Aylur/ags/utils.js"
import Widget from "resource:///com/github/Aylur/ags/widget.js"
import Gtk from "gi://Gtk"
import {MaterialIcon} from "../materialicon"

/**
 * @param notificationObject {import('resource:///com/github/Aylur/ags/service/notifications.js').Notification}
 * @returns {import('types/widgets/box').default}
 * @constructor
 */
export const NotificationIcon = notificationObject => {
  if (notificationObject.image) {
    return Widget.Box({
      vpack: "center",
      class_name: "notif-icon",
      css:
        `background-image: url("${notificationObject.image}");` +
        "background-size: auto 100%;" +
        "background-repeat: no-repeat;" +
        "background-position: center;",
    })
  }

  let icon = "NO_ICON"
  if (lookUpIcon(notificationObject.app_icon)) icon = notificationObject.app_icon
  if (notificationObject.app_entry && lookUpIcon(notificationObject.app_entry))
    icon = notificationObject.app_entry

  return Widget.Box({
    vpack: "center",
    class_name: "notif-icon",
    setup: box => {
      if (icon !== "NO_ICON")
        box.pack_start(
          Widget.Icon({
            icon,
            size: 30,
            halign: Gtk.Align.CENTER,
            hexpand: true,
            valign: Gtk.Align.CENTER,
            setup: () => {
              box.toggleClassName(`notif-icon-material-${notificationObject.urgency}`, true)
            },
          }),
          false,
          true,
          0,
        )
      else
        box.pack_start(
          MaterialIcon(`${notificationObject.urgency === "critical" ? "release_alert" : "chat"}`, "hugeass", {
            hexpand: true,
            setup: () => box.toggleClassName(`notif-icon-material-${notificationObject.urgency}`, true),
          }),
          false,
          true,
          0,
        )
    },
  })
}
