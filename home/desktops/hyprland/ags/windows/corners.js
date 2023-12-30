import { Widget } from "../imports.js";
import { RoundedCorner } from "../modules/lib/roundedcorner.js";

export const CornerTopleft = (monitor) =>
  Widget.Window({
    name: "cornertl",
    layer: "top",
    monitor,
    anchor: ["top", "left"],
    exclusive: false,
    visible: true,
    child: RoundedCorner("topleft", { className: "corner-black" }),
  });
export const CornerTopright = (monitor) =>
  Widget.Window({
    name: "cornertr",
    layer: "top",
    monitor,
    anchor: ["top", "right"],
    exclusive: false,
    visible: true,
    child: RoundedCorner("topright", { className: "corner-black" }),
  });
export const CornerBottomleft = (monitor) =>
  Widget.Window({
    name: "cornerbl",
    layer: "top",
    monitor,
    anchor: ["bottom", "left"],
    exclusive: false,
    visible: true,
    child: RoundedCorner("bottomleft", { className: "corner-black" }),
  });
export const CornerBottomright = (monitor) =>
  Widget.Window({
    name: "cornerbr",
    layer: "top",
    monitor,
    anchor: ["bottom", "right"],
    exclusive: false,
    visible: true,
    child: RoundedCorner("bottomright", { className: "corner-black" }),
  });
