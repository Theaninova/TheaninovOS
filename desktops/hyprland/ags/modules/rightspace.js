import Audio from "resource:///com/github/Aylur/ags/service/audio.js"
import Mpris from "resource:///com/github/Aylur/ags/service/mpris.js"
import Widget from "resource:///com/github/Aylur/ags/widget.js"
import Indicator from "../scripts/indicator.js"
import StatusIcons from "./statusicons.js"
import RoundedCorner from "./lib/roundedcorner.js"
import Tray from "./tray.js"

function ModuleRightSpace() {
  return Widget.EventBox({
    on_scroll_up() {
      if (Audio.speaker == null) return
      Audio.speaker.volume += 0.03
      Indicator.popup(1)
    },
    on_scroll_down() {
      if (Audio.speaker == null) return
      Audio.speaker.volume -= 0.03
      Indicator.popup(1)
    },
    on_primary_click() {
      App.toggleWindow("sideright")
    },
    on_secondary_click() {
      Mpris.getPlayer("")?.next()
    },
    on_middle_click() {
      Mpris.getPlayer("")?.playPause()
    },
    child: Widget.Box({
      homogeneous: false,
      children: [
        Widget.Box({
          hexpand: true,
          className: "spacing-h-5 txt",
          children: [
            Widget.Box({
              hexpand: true,
              className: "spacing-h-15 txt",
              setup: box => {
                box.pack_end(StatusIcons(), false, false, 0)
                box.pack_end(Tray(), false, false, 0)
              },
            }),
          ],
        }),
        RoundedCorner("top", "right", {class_name: "corner-black"}),
      ],
    }),
  })
}

export default ModuleRightSpace
