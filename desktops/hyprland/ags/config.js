import App from "resource:///com/github/Aylur/ags/app.js"
import Bar from "./windows/bar.js"
import Corner from "./windows/corners.js"
import Overview from "./windows/overview.js"

const CLOSE_ANIM_TIME = 150

Utils.exec(`bash -c 'mkdir -p ~/.cache/ags/user'`)
Utils.exec(`sassc ${App.configDir}/scss/main.scss ${App.configDir}/style.css`)
App.resetCss()
App.applyCss(`${App.configDir}/style.css`)

/** @type {Partial<(typeof import('resource:///com/github/Aylur/ags/app.js').default)['config']>} */
const config = {
  style: `${App.configDir}/style.css`,
  closeWindowDelay: {
    sideright: CLOSE_ANIM_TIME,
    sideleft: CLOSE_ANIM_TIME,
    osk: CLOSE_ANIM_TIME,
    session: 1,
    overview: 1,
    cheatsheet: 1,
  },
  windows: [
    Bar(),
    ...Array.from({length: 3}, (_, i) => [
      Corner("top", "left", i),
      Corner("top", "right", i),
      Corner("bottom", "left", i),
      Corner("bottom", "right", i),
    ]),
    Overview(),
    // Indicator(),
    // Cheatsheet(),
    // SideRight(),
    // SideLeft(),
    // Osk(), // On-screen keyboard
    // Session(),
  ],
}

export default config
