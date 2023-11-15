import Widget from "resource:///com/github/Aylur/ags/widget.js"
// @ts-expect-error missing type defs
import Bluetooth from "resource:///com/github/Aylur/ags/service/bluetooth.js"
import Network from "resource:///com/github/Aylur/ags/service/network.js"

export function BluetoothIndicator() {
  return Widget.Icon({
    binds: [
      [
        "icon",
        Bluetooth,
        "enabled",
        (/** @type {boolean} */ enabled) => `bluetooth-${enabled ? "active" : "disabled"}-symbolic`,
      ],
    ],
  })
}

function WiredIndicator() {
  return Widget.Icon({
    binds: [["icon", Network.wired, "icon-name"]],
  })
}

function WifiIndicator() {
  return Widget.Box({
    children: [
      Widget.Icon({
        binds: [["icon", Network.wifi, "icon-name"]],
      }),
      Widget.Label({
        binds: [["label", Network.wifi, "ssid"]],
      }),
    ],
  })
}

function NetworkIndicator() {
  return Widget.Stack({
    transition: "slide_up_down",
    items: [
      ["wifi", WifiIndicator()],
      ["wired", WiredIndicator()],
    ],
    binds: [["shown", Network, "primary", primary => primary || "wired"]],
  })
}

/**
 * @param [props] {Parameters<Widget.Box>[0]}
 */
function StatusIcons(props = {}) {
  return Widget.Box({
    ...props,
    children: [
      Widget.EventBox({
        child: Widget.Box({
          class_name: "spacing-h-15",
          children: [BluetoothIndicator(), NetworkIndicator()],
        }),
      }),
    ],
  })
}

export default StatusIcons
