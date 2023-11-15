import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js"
import Widget from "resource:///com/github/Aylur/ags/widget.js"
import {execAsync} from "resource:///com/github/Aylur/ags/utils.js"

const WORKSPACE_SIDE_PAD = 0.546 // rem
const NUM_OF_WORKSPACES = 9

function ActiveWorkspaceIndicator() {
  return Widget.Box({
    vpack: "center",
    hpack: "start",
    class_name: "bar-ws-active-box",
    connections: [
      [
        Hyprland.active.workspace,
        self => {
          const ws = Hyprland.active.workspace.id
          self.set_margin_left(`-${1.772 * (NUM_OF_WORKSPACES - ws + 1) + WORKSPACE_SIDE_PAD / 2 + 0.4}rem`)
        },
      ],
    ],
    children: [
      Widget.Label({
        justification: "center",
        class_name: "bar-ws-active",
        label: `•`,
      }),
    ],
  })
}

function Workspaces() {
  return Widget.Box({
    hpack: "center",
    children: Array.from({length: NUM_OF_WORKSPACES}, (_, i) => i + 1).map(i =>
      Widget.Button({
        async on_secondary_click() {
          await execAsync(["bash", "-c", `hyprctl dispatch workspace ${i} &`]).catch(print)
        },
        child: Widget.Label({
          justification: "center",
          class_name: "bar-ws txt",
          label: `${i}`,
        }),
      }),
    ),
    connections: [
      [
        Hyprland,
        box => {
          // TODO: connect to the right signal so that it doesn't update too much
          const kids = box.children
          kids.forEach((child, i) => {
            child.child.toggleClassName("bar-ws-occupied", false)
            child.child.toggleClassName("bar-ws-occupied-left", false)
            child.child.toggleClassName("bar-ws-occupied-right", false)
            child.child.toggleClassName("bar-ws-occupied-left-right", false)
          })
          const occupied = Array.from(
            {length: NUM_OF_WORKSPACES},
            (_, i) => Hyprland.getWorkspace(i + 1)?.windows > 0,
          )
          for (let i = 0; i < occupied.length; i++) {
            if (!occupied[i]) continue
            const child = kids[i]
            child.child.toggleClassName(
              `bar-ws-occupied${!occupied[i - 1] ? "-left" : ""}${!occupied[i + 1] ? "-right" : ""}`,
              true,
            )
          }
        },
      ],
    ],
  })
}

function ModuleWorkspaces() {
  return Widget.EventBox({
    async on_scroll_up() {
      await execAsync(["bash", "-c", "hyprctl dispatch workspace -1 &"])
    },
    async on_scroll_down() {
      await execAsync(["bash", "-c", "hyprctl dispatch workspace +1 &"])
    },
    on_primary_click_release() {
      App.toggleWindow("overview")
    },
    on_secondary_click_release() {
      App.toggleWindow("osk")
    },
    child: Widget.Box({
      homogeneous: true,
      className: "bar-group-center",
      children: [
        Widget.Box({
          css: `padding: 0rem ${WORKSPACE_SIDE_PAD}rem;`,
          children: [Workspaces(), ActiveWorkspaceIndicator()],
        }),
      ],
    }),
  })
}

export default ModuleWorkspaces
