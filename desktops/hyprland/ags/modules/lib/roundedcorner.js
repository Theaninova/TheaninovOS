import Widget from "resource:///com/github/Aylur/ags/widget.js"
import Gtk from "gi://Gtk"

/**
 * @param vertical {'top' | 'bottom'}
 * @param horizontal {'left' | 'right'}
 * @param props {Parameters<Widget.DrawingArea>[0]}
 * @returns {import('resource:///com/github/Aylur/ags/widgets/widget.js').default}
 */
function RoundedCorner(vertical, horizontal, props) {
  return Widget.DrawingArea({
    ...props,
    hpack: horizontal === "left" ? "start" : "end",
    vpack: vertical === "top" ? "start" : "end",
    connection: [
      [
        "draw",
        /** @type {Gtk.Widget.DrawSignalCallback} */ (
          (self, cr) => {
            const color = self.get_style_context().get_property("background-color", Gtk.StateFlags.NORMAL)
            const radius = self.get_style_context().get_property("border-radius", Gtk.StateFlags.NORMAL)
            self.set_size_request(radius, radius)

            switch (`${vertical}${horizontal}`) {
              case "topleft":
                cr.arc(radius, radius, radius, Math.PI, (3 * Math.PI) / 2)
                cr.lineTo(0, 0)
                break

              case "topright":
                cr.arc(0, radius, radius, (3 * Math.PI) / 2, 2 * Math.PI)
                cr.lineTo(radius, 0)
                break

              case "bottomleft":
                cr.arc(radius, 0, radius, Math.PI / 2, Math.PI)
                cr.lineTo(0, radius)
                break

              case "bottomright":
                cr.arc(0, 0, radius, 0, Math.PI / 2)
                cr.lineTo(radius, radius)
                break
            }

            cr.closePath()
            cr.setSourceRGBA(color.red, color.green, color.blue, color.alpha)
            cr.fill()
          }
        ),
      ],
    ],
  })
}

export default RoundedCorner
