import Widget from "resource:///com/github/Aylur/ags/widget.js"
import SessionScreen from "../modules/sessionscreen.js"

export default () =>
  Widget.Window({
    // On-screen keyboard
    name: "session",
    popup: true,
    visible: false,
    focusable: true,
    layer: "overlay",
    // anchor: ['top', 'bottom', 'left', 'right'],
    child: SessionScreen(),
  })
