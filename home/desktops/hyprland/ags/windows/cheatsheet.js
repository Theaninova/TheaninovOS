const { Gdk, Gtk } = imports.gi;
import { Service, Widget } from '../imports.js';
import { Keybinds } from "../modules/keybinds.js";
import { setupCursorHover } from "../modules/lib/cursorhover.js";

const cheatsheetHeader = () => Widget.CenterBox({
    vertical: false,
    startWidget: Widget.Box({}),
    centerWidget: Widget.Box({
        vertical: true,
        className: "spacing-h-15",
        children: [
            Widget.Box({
                halign: 'center',
                className: 'spacing-h-5',
                children: [
                    Widget.Label({
                        halign: 'center',
                        style: 'margin-right: 0.682rem;',
                        className: 'txt-title txt',
                        label: 'Cheat sheet',
                    }),
                    Widget.Label({
                        valign: 'center',
                        className: "cheatsheet-key txt-small",
                        label: "",
                    }),
                    Widget.Label({
                        valign: 'center',
                        className: "cheatsheet-key-notkey txt-small",
                        label: "+",
                    }),
                    Widget.Label({
                        valign: 'center',
                        className: "cheatsheet-key txt-small",
                        label: "/",
                    })
                ]
            }),
            Widget.Label({
                justify: Gtk.Justification.CENTER,
                className: 'txt-small txt',
                label: 'Sheet data stored in ~/.config/ags/data/keybinds.js\nChange keybinds in ~/.config/hypr/keybinds.conf'
            }),
        ]
    }),
    endWidget: Widget.Button({
        valign: 'start',
        halign: 'end',
        className: "cheatsheet-closebtn icon-material txt txt-hugeass",
        onClicked: () => {
            App.toggleWindow('cheatsheet');
        },
        child: Widget.Label({
            className: 'icon-material txt txt-hugeass',
            label: 'close'
        }),
        setup: (button) => setupCursorHover(button),
    }),
});

const clickOutsideToClose = Widget.EventBox({
    onPrimaryClick: () => App.closeWindow('cheatsheet'),
    onSecondaryClick: () => App.closeWindow('cheatsheet'),
    onMiddleClick: () => App.closeWindow('cheatsheet'),
});

export default () => Widget.Window({
    name: 'cheatsheet',
    exclusive: false,
    focusable: true,
    popup: true,
    visible: false,
    child: Widget.Box({
        vertical: true,
        children: [
            clickOutsideToClose,
            Widget.Box({
                vertical: true,
                className: "cheatsheet-bg spacing-v-15",
                children: [
                    cheatsheetHeader(),
                    Keybinds(),
                ]
            }),
        ],
    })
});
