import Widget from "resource:///com/github/Aylur/ags/widget.js"

/**
 * @param options {{materialIconName: string; name: string; actionName: string; content: string; onActivate: (self: ReturnType<Widget.Button>) => void;}}
 */
function SearchItem({materialIconName, name, actionName, content, onActivate}) {
  const actionText = Widget.Revealer({
    reveal_child: false,
    transition: "crossfade",
    transition_duration: 200,
    child: Widget.Label({
      class_name: "overview-search-results-txt txt txt-small txt-action",
      label: actionName,
    }),
  })

  const actionTextRevealer = Widget.Revealer({
    reveal_child: false,
    transition: "slide_left",
    transition_duration: 300,
    child: actionText,
  })

  return Widget.Button({
    class_name: "overview-search-result-btn",
    on_clicked: onActivate,
    child: Widget.Box({
      children: [
        Widget.Box({
          vertical: false,
          children: [
            Widget.Label({
              class_name: `icon-material overview-search-results-icon`,
              label: materialIconName,
            }),
            Widget.Box({
              vertical: true,
              children: [
                Widget.Label({
                  halign: "start",
                  class_name: "overview-search-results-txt txt txt-smallie txt-subtext",
                  label: name,
                  truncate: "end",
                }),
                Widget.Label({
                  halign: "start",
                  class_name: "overview-search-results-txt txt txt-norm",
                  label: content,
                  truncate: "end",
                }),
              ],
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
          actionText.reveal_child = true
          actionTextRevealer.reveal_child = true
        },
      ],
      [
        "focus-out-event",
        function () {
          actionText.reveal_child = false
          actionTextRevealer.reveal_child = false
        },
      ],
    ],
  })
}

export default SearchItem
