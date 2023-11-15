import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js"
import {setupCursorHover} from "./lib/cursorhover.js"
import RoundedCorner from "./lib/roundedcorner.js"
import Brightness from "../scripts/brightness.js"
import Indicator from "../scripts/indicator.js"
import Widget from "resource:///com/github/Aylur/ags/widget.js"

/**
 * Removes everything after the last em dash, en dash, minus, vertical bar, or middle (note: maybe add open parenthesis?)
 * @example
 *  truncateTitle("• Discord | #ricing-theming | r/unixporn — Mozilla Firefox") // "• Discord | #ricing-theming"
 * @example
 *  truncateTitle("GJS Error · Issue #112 · Aylur/ags — Mozilla Firefox") // "GJS Error · Issue #112"
 * @param str {string}
 * @returns {string}
 */
function truncateTitle(str) {
  return str.replace(/\s*[—–\-|·][^—–\-|·]+$/, "")
}

function WindowTitle() {
  return Widget.Button({
    class_name: "bar-space-button",
    child: Widget.Box({
      vertical: true,
      children: [
        Widget.Scrollable({
          hexpand: true,
          vexpand: true,
          hscroll: "automatic",
          vscroll: "never",
          child: Widget.Box({
            vertical: true,
            children: [
              Widget.Label({
                xalign: 0,
                className: "txt txt-smaller bar-topdesc",
                connections: [
                  [
                    Hyprland,
                    label => {
                      label.label =
                        Hyprland.active.client._class.length === 0 ? "Desktop" : Hyprland.active.client._class
                    },
                  ],
                ],
              }),
              Widget.Label({
                xalign: 0,
                className: "txt txt-smallie",
                connections: [
                  [
                    Hyprland,
                    label => {
                      // Hyprland.active.client
                      label.label =
                        Hyprland.active.client._title.length === 0
                          ? `Workspace ${Hyprland.active.workspace.id}`
                          : truncateTitle(Hyprland.active.client._title)
                    },
                  ],
                ],
              }),
            ],
          }),
        }),
      ],
    }),
    setup: button => setupCursorHover(button),
  })
}

export const ModuleLeftSpace = () =>
  Widget.EventBox({
    on_scroll_up() {
      Indicator.popup(1) // Since the brightness and speaker are both on the same window
      Brightness.screen_value += 0.05
    },
    on_scroll_down() {
      Indicator.popup(1) // Since the brightness and speaker are both on the same window
      Brightness.screen_value -= 0.05
    },
    child: Widget.Box({
      homogeneous: false,
      children: [
        RoundedCorner("top", "left", {className: "corner-black"}),
        Widget.Overlay({
          overlays: [
            Widget.Box({hexpand: true}),
            Widget.Box({
              class_name: "bar-sidemodule",
              hexpand: true,
              children: [WindowTitle()],
            }),
          ],
        }),
      ],
    }),
  })
