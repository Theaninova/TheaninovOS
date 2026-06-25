hl.config({
	general = {
		col = {
			inactive_border = "rgba(00000000)",
			active_border = "rgba(00000000)",
		},
		border_size = 0,
		extend_border_grab_area = 4,
    -- stylua: ignore
    gaps_in = {{custom.padding}},
    -- stylua: ignore
    gaps_out = {{custom.double_padding}},
	},
	decoration = {
    -- stylua: ignore
    rounding = {{custom.radius}},
		--[[ motion_blur = {
			enabled = true,
		},]]
		blur = {
      -- stylua: ignore
      size = {{custom.blur}},
			passes = 3,
			popups = true,
		},
		inactive_opacity = 0.8,
		shadow = {
			enabled = true,
			range = 32,
			render_power = 8,
			color = "rgba(000000aa)",
			color_inactive = "rgba(00000011)",
		},
	},
	animations = {
		enabled = true,
	},
})

hl.curve("default", { type = "spring", mass = 1, stiffness = 90, dampening = 30 })
hl.curve("linear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.5, 0.5 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 1, spring = "default", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 1, spring = "default", style = "slide bottom" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, spring = "default", style = "slide bottom" })

hl.animation({ leaf = "border", enabled = true, speed = 1, spring = "default" })

hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "linear" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 4, bezier = "linear" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 4, bezier = "linear" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 1, spring = "default", style = "slidevert" })
