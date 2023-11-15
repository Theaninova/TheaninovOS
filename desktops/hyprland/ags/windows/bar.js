import ModuleWorkspaces from "../modules/workspaces.js"
import ModuleSystem from "../modules/system.js"
import {ModuleLeftSpace} from "../modules/leftspace.js"
import ModuleRightSpace from "../modules/rightspace.js"
import RoundedCorner from "../modules/lib/roundedcorner.js"
import Widget from "resource:///com/github/Aylur/ags/widget.js"

const left = Widget.Box({
  class_name: "bar-sidemodule",
  children: [
    /* ModuleMusic() */
  ],
})

const center = Widget.Box({
  children: [
    RoundedCorner("top", "right", {className: "corner-bar-group"}),
    ModuleWorkspaces(),
    RoundedCorner("top", "left", {className: "corner-bar-group"}),
  ],
})

const right = Widget.Box({
  class_name: "bar-sidemodule",
  children: [ModuleSystem()],
})

export default () =>
  Widget.Window({
    name: "bar",
    anchor: ["top", "left", "right"],
    monitor: 1,
    exclusive: true,
    visible: true,
    child: Widget.CenterBox({
      class_name: "bar-bg",
      start_widget: ModuleLeftSpace(),
      center_widget: Widget.Box({
        class_name: "spacing-h--20",
        children: [left, center, right],
      }),
      end_widget: ModuleRightSpace(),
    }),
  })
