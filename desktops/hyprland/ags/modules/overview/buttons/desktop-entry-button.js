import Widget from "resource:///com/github/Aylur/ags/widget.js"
import App from "resource:///com/github/Aylur/ags/app.js"

function DesktopEntryButton(app) {
  const actionText = Widget.Revealer({
    reveal_child: false,
    transition: "crossfade",
    transitionDuration: 200,
    child: Widget.Label({
      class_name: "overview-search-results-txt txt txt-small txt-action",
      label: "Launch",
    }),
  })

  const actionTextRevealer = Widget.Revealer({
    reveal_child: false,
    transition: "slide_left",
    transitionDuration: 300,
    child: actionText,
  })

  return Widget.Button({
    class_name: "overview-search-result-btn",
    on_clicked() {
      App.closeWindow("overview")
      app.launch()
    },
    child: Widget.Box({
      children: [
        Widget.Box({
          vertical: false,
          children: [
            Widget.Icon({
              class_name: "overview-search-results-icon",
              icon: app.iconName,
              size: 35, // TODO: Make this follow font size. made for 11pt.
            }),
            Widget.Label({
              class_name: "overview-search-results-txt txt txt-norm",
              label: app.name,
            }),
            Widget.Box({hexpand: true}),
            actionTextRevealer,
          ],
        }),
      ],
    }),
    connections: [
      [
        "focus-in-event",
        function () {
          actionText.revealChild = true
          actionTextRevealer.revealChild = true
        },
      ],
      [
        "focus-out-event",
        function () {
          actionText.revealChild = false
          actionTextRevealer.revealChild = false
        },
      ],
    ],
  })
}

export default DesktopEntryButton
