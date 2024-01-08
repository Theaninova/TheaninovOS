import Widget from "resource:///com/github/Aylur/ags/widget.js";
import icons from "../../icons.js";
import Brightness from "../../services/brightness.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";

const CanSupportBrightness = () => Utils.exec("which gbmonctl");

const BrightnessSlider = () =>
  Widget.Slider({
    draw_value: false,
    hexpand: true,
    binds: [["value", Brightness, "screen"]],
    on_change: ({ value }) => (Brightness.screen = value),
  });

export default () =>
  Widget.Box({
    children: [
      Widget.Button({
        child: Widget.Icon(icons.brightness.indicator),
        binds: [
          [
            "tooltip-text",
            Brightness,
            "screen",
            (v) => `Screen Brightness: ${Math.floor(v * 100)}%`,
          ],
        ],
      }),
      BrightnessSlider(),
    ],
  });
