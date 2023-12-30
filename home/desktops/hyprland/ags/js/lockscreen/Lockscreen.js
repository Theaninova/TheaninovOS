import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Avatar from "../misc/Avatar.js";
import Lockscreen from "../services/lockscreen.js";
import Layer from "gi://GtkLayerShell";

const PasswordEntry = () =>
  Widget.Box({
    children: [
      Widget.Entry({
        connections: [[Lockscreen, (entry) => (entry.text = ""), "lock"]],
        visibility: false,
        placeholder_text: "Password",
        on_accept: ({ text }) => Lockscreen.auth(text || ""),
        hpack: "center",
        hexpand: true,
      }),
      Widget.Spinner({
        active: true,
        vpack: "center",
        connections: [
          [Lockscreen, (w, auth) => (w.visible = auth), "authenticating"],
        ],
      }),
    ],
  });

/** @param {number} monitor */
export default (monitor) => {
  const win = Widget.Window({
    name: `lockscreen${monitor}`,
    class_name: "lockscreen",
    monitor,
    layer: "overlay",
    visible: false,
    connections: [[Lockscreen, (w, lock) => (w.visible = lock), "lock"]],
    child: Widget.Box({
      css: "min-width: 3000px; min-height: 2000px;",
      class_name: "shader",
      child: Widget.Box({
        class_name: "content",
        vertical: true,
        hexpand: true,
        vexpand: true,
        hpack: "center",
        vpack: "center",
        children: [
          Avatar({
            hpack: "center",
            vpack: "center",
          }),
          PasswordEntry(),
        ],
      }),
    }),
  });

  Layer.set_keyboard_mode(win, Layer.KeyboardMode.EXCLUSIVE);
  return win;
};
