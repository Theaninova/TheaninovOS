local wezterm = require("wezterm")

local config = {
	font = wezterm.font("JetBrains Mono"),
	enable_tab_bar = false,
	display_pixel_geometry = "BGR",
	freetype_load_target = "HorizontalLcd",
	freetype_load_flags = "NO_HINTING",
	freetype_render_target = "HorizontalLcd",
	font_size = 13.0,
	default_prog = { "/run/current-system/sw/bin/fish" },
}

return config
