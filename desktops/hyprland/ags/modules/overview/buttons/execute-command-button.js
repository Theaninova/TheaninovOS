import SearchItem from "../search-item"

function ExecuteCommandButton({command, terminal = false}) {
  SearchItem({
    materialIconName: `${terminal ? "terminal" : "settings_b_roll"}`,
    name: `Run command`,
    actionName: `Execute ${terminal ? "in terminal" : ""}`,
    content: `${command}`,
    onActivate: () => execAndClose(command, terminal),
  })
}
