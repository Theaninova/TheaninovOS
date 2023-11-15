import Todo from "../../scripts/todo"
import {execAsync} from "resource:///com/github/Aylur/ags/utils.js"
import App from "resource:///com/github/Aylur/ags/app.js"

/** @type {Record<string, string[] | undefined>} */
const COMMANDS = {
  ">raw": [
    `bash`,
    `-c`,
    `hyprctl keyword input:force_no_accel $(( 1 - $(hyprctl getoption input:force_no_accel -j | gojq ".int") ))`,
    `&`,
  ],
  ">img": [`bash`, `-c`, `${App.configDir}/scripts/color_generation/switchwall.sh`, `&`],
  ">light": [`bash`, `-c`, `mkdir -p ~/.cache/ags/user && echo "-l" > ~/.cache/ags/user/colormode.txt`, `&`],
  ">dark": [`bash`, `-c`, `mkdir -p ~/.cache/ags/user && echo "" > ~/.cache/ags/user/colormode.txt`, `&`],
  ">material": [
    `bash`,
    `-c`,
    `mkdir -p ~/.cache/ags/user && echo "material" > ~/.cache/ags/user/colorbackend.txt`,
    `&`,
  ],
  ">pywal": [
    `bash`,
    `-c`,
    `mkdir -p ~/.cache/ags/user && echo "material" > ~/.cache/ags/user/colorbackend.txt`,
    `&`,
  ],
  ">shutdown": [`bash`, `-c`, `systemctl poweroff`],
  ">reboot": [`bash`, `-c`, `systemctl reboot`],
  ">sleep": [`bash`, `-c`, `systemctl suspend`],
  ">logout": [`bash`, `-c`, `loginctl terminate-user $USER`],
}

/**
 * @param command {string}
 */
export function launchCustomCommand(command) {
  App.closeWindow("overview")
  const args = command.split(" ")
  const exec = COMMANDS[args[0]]
  if (exec !== undefined) {
    execAsync(exec).catch(print)
  } else if (args[0] === ">todo") {
    Todo.add(args.slice(1).join(" "))
  }
}
