import Widget from "resource:///com/github/Aylur/ags/widget.js"
import {lookUpIcon} from "resource:///com/github/Aylur/ags/utils.js"
import GLib from "gi://GLib"
import Gtk from "gi://Gtk"
import Gdk from "gi://Gdk?version=3.0"
import {MaterialIcon} from "./materialicon.js"
import {setupCursorHover} from "./cursorhover.js"

/**
 * @typedef {{appIcon: string; appEntry: string; image?: string; urgency: 'critical'}} NotificationObject
 */

/**
 * @param notificationObject {NotificationObject}
 * @returns {import('types/widgets/box').default}
 * @constructor
 */
const NotificationIcon = notificationObject => {
  if (notificationObject.image) {
    return Widget.Box({
      valign: Gtk.Align.CENTER,
      hexpand: false,
      className: "notif-icon",
      style:
        `background-image: url("${notificationObject.image}");` +
        "background-size: auto 100%;" +
        "background-repeat: no-repeat;" +
        "background-position: center;",
    })
  }

  let icon = "NO_ICON"
  if (lookUpIcon(notificationObject.appIcon)) icon = notificationObject.appIcon
  if (lookUpIcon(notificationObject.appEntry)) icon = notificationObject.appEntry

  return Widget.Box({
    valign: Gtk.Align.CENTER,
    hexpand: false,
    className: "notif-icon",
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

/**
 * @param options {{notifObject?: NotificationObject; isPopup?: boolean, props?: object}}
 * @returns {import('types/widgets/revealer').default}
 */
export default ({notifObject, isPopup = false, props = {}} = {}) => {
  const command = isPopup ? () => notifObject.dismiss() : () => notifObject.close()
  const destroyWithAnims = () => {
    widget.sensitive = false
    notificationBox.setStyle(rightAnim1)
    Utils.timeout(200, () => {
      wholeThing.revealChild = false
    })
    Utils.timeout(400, () => {
      command()
      wholeThing.destroy()
    })
  }
  const widget = Widget.EventBox({
    onHover: self => {
      self.window.set_cursor(Gdk.Cursor.new_from_name(display, "grab"))
      if (!wholeThing._hovered) wholeThing._hovered = true
    },
    onHoverLost: self => {
      self.window.set_cursor(null)
      if (wholeThing._hovered) wholeThing._hovered = false
      if (isPopup) {
        command()
      }
    },
    onMiddleClick: self => {
      destroyWithAnims()
    },
  })
  const wholeThing = Widget.Revealer({
    properties: [
      ["id", notifObject.id],
      ["close", undefined],
      ["hovered", false],
      ["dragging", false],
      ["destroyWithAnims", () => destroyWithAnims],
    ],
    revealChild: false,
    transition: "slide_down",
    transitionDuration: 200,
    child: Widget.Box({
      // Box to make sure css-based spacing works
      homogeneous: true,
    }),
  })

  const display = Gdk.Display.get_default()
  const notificationContent = Widget.Box({
    ...props,
    className: `${isPopup ? "popup-" : ""}notif-${notifObject.urgency} spacing-h-10`,
    children: [
      NotificationIcon(notifObject),
      Widget.Box({
        valign: "center",
        vertical: true,
        hexpand: true,
        children: [
          Widget.Box({
            children: [
              Widget.Label({
                xalign: 0,
                className: "txt-small txt-semibold titlefont",
                justify: Gtk.Justification.LEFT,
                hexpand: true,
                maxWidthChars: 24,
                ellipsize: 3,
                wrap: true,
                useMarkup: notifObject.summary.startsWith("<"),
                label: notifObject.summary,
              }),
            ],
          }),
          Widget.Label({
            xalign: 0,
            className: "txt-smallie notif-body-${urgency}",
            useMarkup: true,
            justify: Gtk.Justification.LEFT,
            wrap: true,
            label: notifObject.body,
          }),
        ],
      }),
      Widget.Box({
        className: "spacing-h-5",
        children: [
          Widget.Label({
            valign: "center",
            className: "txt-smaller txt-semibold",
            justify: Gtk.Justification.RIGHT,
            setup: label => {
              const messageTime = GLib.DateTime.new_from_unix_local(notifObject.time)
              if (messageTime.get_day_of_year() == GLib.DateTime.new_now_local().get_day_of_year()) {
                label.label = messageTime.format("%H:%M")
              } else if (
                messageTime.get_day_of_year() ==
                GLib.DateTime.new_now_local().get_day_of_year() - 1
              ) {
                label.label = messageTime.format("%H:%M\nYesterday")
              } else {
                label.label = messageTime.format("%H:%M\n%d/%m")
              }
            },
          }),
          Widget.Button({
            className: "notif-close-btn",
            onClicked: () => {
              destroyWithAnims()
            },
            child: MaterialIcon("close", "large", {
              valign: "center",
            }),
            setup: button => setupCursorHover(button),
          }),
        ],
      }),

      // what is this? i think it should be at the bottom not on the right
      // Box({
      //     className: 'actions',
      //     children: actions.map(action => Button({
      //         className: 'action-button',
      //         onClicked: () => Notifications.invoke(id, action.id),
      //         hexpand: true,
      //         child: Label(action.label),
      //     })),
      // }),
    ],
  })

  // Gesture stuff

  const gesture = Gtk.GestureDrag.new(widget)
  let initialDir = 0
  // in px
  const startMargin = 0
  const dragThreshold = 100
  // in rem
  const maxOffset = 10.227
  const endMargin = 20.455
  const disappearHeight = 6.818
  const leftAnim1 = `transition: 200ms cubic-bezier(0.05, 0.7, 0.1, 1);
                       margin-left: -${Number(maxOffset + endMargin)}rem;
                       margin-right: ${Number(maxOffset + endMargin)}rem;
                       opacity: 0;`

  const rightAnim1 = `transition: 200ms cubic-bezier(0.05, 0.7, 0.1, 1);
                        margin-left:   ${Number(maxOffset + endMargin)}rem;
                        margin-right: -${Number(maxOffset + endMargin)}rem;
                        opacity: 0;`

  const notificationBox = Widget.Box({
    properties: [
      ["leftAnim1", leftAnim1],
      ["rightAnim1", rightAnim1],
      ["ready", false],
    ],
    homogeneous: true,
    children: [notificationContent],
    connections: [
      [
        gesture,
        self => {
          var offset = gesture.get_offset()[1]
          if (initialDir == 0 && offset != 0) initialDir = offset > 0 ? 1 : -1

          if (offset > 0) {
            if (initialDir < 0) self.setStyle(`margin-left: 0px; margin-right: 0px;`)
            else
              self.setStyle(`
                            margin-left:   ${Number(offset + startMargin)}px;
                            margin-right: -${Number(offset + startMargin)}px;
                        `)
          } else if (offset < 0) {
            if (initialDir > 0) self.setStyle(`margin-left: 0px; margin-right: 0px;`)
            else {
              offset = Math.abs(offset)
              self.setStyle(`
                            margin-right: ${Number(offset + startMargin)}px;
                            margin-left: -${Number(offset + startMargin)}px;
                        `)
            }
          }

          wholeThing._dragging = Math.abs(offset) > 10

          if (widget.window) widget.window.set_cursor(Gdk.Cursor.new_from_name(display, "grabbing"))
        },
        "drag-update",
      ],

      [
        gesture,
        self => {
          if (!self._ready) {
            wholeThing.revealChild = true
            self._ready = true
            return
          }

          const offset = gesture.get_offset()[1] ?? NaN

          if (Math.abs(offset) > dragThreshold && offset * initialDir > 0) {
            if (offset > 0) {
              self.set_style(rightAnim1)
              widget.sensitive = false
            } else {
              self.set_style(leftAnim1)
              widget.sensitive = false
            }
            Utils.timeout(200, () => {
              wholeThing.revealChild = false
            })
            Utils.timeout(400, () => {
              command()
              wholeThing.destroy()
            })
          } else {
            self.set_style(`transition: margin 200ms cubic-bezier(0.05, 0.7, 0.1, 1), opacity 200ms cubic-bezier(0.05, 0.7, 0.1, 1);
                                   margin-left:  ${startMargin}px;
                                   margin-right: ${startMargin}px;
                                   margin-bottom: unset; margin-top: unset;
                                   opacity: 1;`)
            if (widget.window) widget.window.set_cursor(Gdk.Cursor.new_from_name(display, "grab"))

            wholeThing._dragging = false
          }
          initialDir = 0
        },
        "drag-end",
      ],
    ],
  })
  widget.add(notificationBox)
  wholeThing.child.children = [widget]

  return wholeThing
}
