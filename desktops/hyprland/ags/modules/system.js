import {execAsync} from "resource:///com/github/Aylur/ags/utils.js"
import Widget from "resource:///com/github/Aylur/ags/widget.js"

function Clock() {
  return Widget.Box({
    vpack: "center",
    class_name: "spacing-h-5",
    children: [
      Widget.Label({
        class_name: "bar-clock",
        connections: [
          [
            5000,
            label => {
              execAsync([`date`, "+%H:%M"])
                .then(timeString => {
                  label.label = timeString
                })
                .catch(print)
            },
          ],
        ],
      }),
      Widget.Label({
        class_name: "txt-norm txt",
        label: "•",
      }),
      Widget.Label({
        class_name: "txt-smallie txt",
        connections: [
          [
            5000,
            label => {
              execAsync(["date", "+%A, %d/%m"])
                .then(dateString => {
                  label.label = dateString
                })
                .catch(print)
            },
          ],
        ],
      }),
    ],
  })
}

function ModuleSystem() {
  return Widget.EventBox({
    async on_scroll_up() {
      await execAsync("hyprctl dispatch workspace -1")
    },
    async on_scroll_down() {
      await execAsync("hyprctl dispatch workspace +1")
    },
    child: Widget.Box({
      class_name: "bar-group-margin bar-sides",
      children: [
        Widget.Box({
          class_name: "bar-group bar-group-standalone bar-group-pad-system spacing-h-15",
          children: [Clock()],
        }),
      ],
    }),
  })
}

export default ModuleSystem
