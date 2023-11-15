import {Widget} from "../imports.js"
import Osd from "../modules/onscreendisplay.js"

/**
 * @param monitor {number}
 * @returns {import('resource:///com/github/Aylur/ags/widgets/window.js').default}
 */
export default monitor =>
  Widget.Window({
    name: `indicator${monitor}`,
    monitor,
    className: "indicator",
    layer: "overlay",
    visible: true,
    anchor: ["top"],
    child: Osd(),
  })
