/**
 * A Theme is a set of options that will be applied
 * ontop of the default values. see options.js for possible options
 */
import { Theme, WP, lightColors, darkColors } from "./settings/theme.js";

export default [
  Theme({
    name: "Latte",
    icon: "󰄛",
    "desktop.screen_corners": false,
    "bar.style": "floating",
    "desktop.wallpaper.img": WP + "Lakeside-2-1.jpg",
    ...darkColors,
  }),
  Theme({
    name: "Frappe",
    icon: "󰄛",
    "desktop.screen_corners": false,
    "bar.style": "floating",
    "desktop.wallpaper.img": WP + "Lakeside-2-10.jpg",
    ...lightColors,
    "theme.widget.bg": "$accent",
    "theme.widget.opacity": 64,
  }),
  /*Theme({
    name: "Leaves",
    icon: "󰌪",
    "desktop.wallpaper.img": WP + "leaves.jpg",
    "theme.accent.accent": "$green",
    "theme.accent.gradient": "to right, $accent, darken($accent, 14%)",
    "theme.widget.opacity": 92,
    "border.opacity": 86,
    "theme.bg": "transparentize(#171717, 0.3)",
    "bar.style": "floating",
    radii: 0,
  }),
  Theme({
    name: "Ivory",
    icon: "󰟆",
    ...lightColors,
    "desktop.wallpaper.img": WP + "ivory.png",
    "desktop.wallpaper.fg": "$bg_color",
    "desktop.screen_corners": false,
    "bar.style": "separated",
    "theme.widget.bg": "$accent",
    "theme.widget.opacity": 64,
    "desktop.drop_shadow": false,
    "border.width": 2,
    "border.opacity": 0,
    "theme.accent.gradient": "to right, $accent, darken($accent, 6%)",
    "hypr.inactive_border": "rgba(111111FF)",
    "bar.separators": false,
  }),
  Theme({
    name: "Space",
    icon: "",
    "desktop.wallpaper.img": WP + "space.jpg",
    spacing: 11,
    padding: 10,
    radii: 12,
    "theme.accent.accent": "$magenta",
    "desktop.screen_corners": false,
    "desktop.clock.enable": false,
    "bar.separators": false,
    "bar.icon": "",
    "theme.bg": "transparentize(#171717, 0.3)",
    "theme.widget.opacity": 95,
    "bar.flat_buttons": false,
  }),*/
];