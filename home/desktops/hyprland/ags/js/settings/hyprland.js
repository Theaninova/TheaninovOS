import App from "resource:///com/github/Aylur/ags/app.js";
import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import options from "../options.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";

const noIgnorealpha = ["verification", "powermenu", "lockscreen"];

/** @param {Array<string>} batch */
function sendBatch(batch) {
  const cmd = batch
    .filter((x) => !!x)
    .map((x) => `keyword ${x}`)
    .join("; ");

  Hyprland.sendMessage(`[[BATCH]]/${cmd}`);
}

/** @param {string} scss */
function getColor(scss) {
  if (scss.includes("#")) return scss.replace("#", "");

  if (scss.includes("$")) {
    const opt = options
      .list()
      .find((opt) => opt.scss === scss.replace("$", ""));
    return opt?.value.replace("#", "") || "ff0000";
  }
}

export function hyprlandInit() {
  sendBatch(
    Array.from(App.windows).flatMap(([name]) => [
      `layerrule blur, ${name}`,
      noIgnorealpha.some((skip) => name.includes(skip))
        ? ""
        : `layerrule ignorealpha 0.6, ${name}`,
    ]),
  );
}

export async function setupHyprland() {
  /*Hyprland.event("activewindowv2", async (addr) => {
    const client = Hyprland.getClient(addr);
    if (!client.pinned || !client.floating) return;
    const x = client.at[0];
    console.log(
      await Utils.execAsync(`hyprctl dispatch moveactive exact ${x} 80`),
    );
  });*/

  const wm_gaps = Math.floor(
    options.hypr.wm_gaps_multiplier.value * options.spacing.value,
  );
  const border_width = options.border.width.value;
  const radii = options.radii.value;
  const drop_shadow = options.desktop.drop_shadow.value;
  const inactive_border = options.hypr.inactive_border.value;
  const accent = getColor(options.theme.accent.accent.value);

  sendBatch([
    `general:border_size ${border_width}`,
    `general:gaps_out ${wm_gaps}`,
    `general:gaps_in ${Math.floor(wm_gaps / 2)}`,
    `general:col.active_border rgba(${accent}ff)`,
    `general:col.inactive_border ${inactive_border}`,
    `decoration:rounding ${radii}`,
    `decoration:drop_shadow ${drop_shadow ? "yes" : "no"}`,
  ]);
}
