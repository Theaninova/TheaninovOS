import Widget from "resource:///com/github/Aylur/ags/widget.js"
import RoundedCorner from "../modules/lib/roundedcorner.js"

/**
 * @param vertical {'top' | 'bottom'}
 * @param horizontal {'left' | 'right'}
 * @param monitor {number}
 * @returns {import('resource:///com/github/Aylur/ags/widgets/window.js').default}
 */
function Corner(vertical, horizontal, monitor) {
  return Widget.Window({
    name: `corner${vertical[0]}${horizontal[0]}`,
    layer: "top",
    monitor,
    anchor: [vertical, horizontal],
    exclusive: false,
    visible: true,
    child: RoundedCorner(vertical, horizontal, {class_name: monitor === 1 ? "corner" : "corner-black"}),
  })
}

export default Corner
