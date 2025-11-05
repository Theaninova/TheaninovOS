hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name="md3-evo"

let g:neovide_opacity = 1.0
let g:neovide_floating_corner_radius = 0.5
let g:neovide_normal_opacity = {{custom.transparency}}
let g:neovide_padding_top = {{custom.padding}}
let g:neovide_padding_bottom = {{custom.padding}}
let g:neovide_padding_left = {{custom.padding}}
let g:neovide_padding_right = {{custom.padding}}
let g:neovide_floating_blur_amount_x = {{custom.blur}}
let g:neovide_floating_blur_amount_y = {{custom.blur}}
let g:neovide_floating_shadow = v:true
let g:neovide_floating_z_height = 10
let g:neovide_light_angle_degrees = 45
let g:neovide_light_radius = 5

let g:terminal_color_0 = "{{colors.surface.default.hex}}"
let g:terminal_color_1 = "{{colors.red.default.hex}}"
let g:terminal_color_2 = "{{colors.green.default.hex}}"
let g:terminal_color_3 = "{{colors.yellow.default.hex}}"
let g:terminal_color_4 = "{{colors.blue.default.hex}}"
let g:terminal_color_5 = "{{colors.magenta.default.hex}}"
let g:terminal_color_6 = "{{colors.cyan.default.hex}}"
let g:terminal_color_7 = "{{colors.on_surface.default.hex}}"

let g:terminal_color_8 = "{{colors.outline_variant.default.hex}}"
let g:terminal_color_9 = "{{colors.red.default.hex}}"
let g:terminal_color_10 = "{{colors.green.default.hex}}"
let g:terminal_color_11 = "{{colors.yellow.default.hex}}"
let g:terminal_color_12 = "{{colors.blue.default.hex}}"
let g:terminal_color_13 = "{{colors.magenta.default.hex}}"
let g:terminal_color_14 = "{{colors.cyan.default.hex}}"
let g:terminal_color_15 = "{{colors.on_surface_variant.default.hex}}"
set termguicolors

set background={{mode | to_lower}}

if exists("g:neovide")
  hi! Normal guibg={{colors.surface.default.hex}} guifg={{colors.on_surface.default.hex}}
  set pumblend=0
  set winblend=0
else
  hi! Normal ctermbg=NONE guibg=NONE guifg={{colors.on_surface.default.hex}}
end

hi! Pmenu ctermbg=none guibg=none guifg={{colors.on_surface.default.hex}}
hi! PmenuSel guibg={{colors.primary.default.hex}} guifg={{colors.on_primary.default.hex}}
hi! PmenuThumb guifg=none guifg={{colors.primary.default.hex}}
hi! link NormalFloat Normal
hi! FloatBorder guifg={{colors.primary.default.hex}}
hi! CursorColumn guibg={{colors.primary.default.hex}} guifg={{colors.on_primary.default.hex}}
hi! CursorLine guibg={{colors.primary.default.hex}} guifg={{colors.on_primary.default.hex}}
hi! WildMenu guibg={{colors.primary.default.hex}} guifg={{colors.on_primary.default.hex}}
hi! MoreMsg guifg={{colors.primary.default.hex}}
hi! Question guifg={{colors.secondary.default.hex}}

hi! Title guifg={{colors.primary.default.hex}}
hi! FloatTitle guifg={{colors.primary.default.hex}}
hi! Visual guifg={{colors.on_primary.default.hex}} guibg={{colors.primary.default.hex}}

hi! Folded guibg={{colors.secondary.default.hex}} guifg={{colors.on_secondary.default.hex}}
hi! FoldColumn guibg={{colors.secondary.default.hex}} guifg={{colors.on_secondary.default.hex}}

hi! Conceal guibg={{colors.secondary_container.default.hex}} guifg={{colors.on_secondary_container.default.hex}}

hi! TabLine guibg={{colors.primary_container.default.hex}} guifg={{colors.on_primary_container.default.hex}}
hi! TabLineFill guibg={{colors.primary.default.hex}} guifg={{colors.on_primary.default.hex}}

hi! SpecialKey guifg={{colors.primary.default.hex}}
hi! Directory guifg={{colors.primary.default.hex}}
hi! Search guifg={{colors.on_tertiary.default.hex}} guibg={{colors.tertiary.default.hex}}

hi! CmpItemKindCopilot guifg={{colors.cyan.default.hex}}
hi! CmpItemKindNpm guifg={{colors.red.default.hex}}

hi! Error guibg={{colors.danger_container.default.hex}} guifg={{colors.on_danger_container.default.hex}}
hi! ErrorMsg guibg={{colors.danger_container.default.hex}} guifg={{colors.on_danger_container.default.hex}}
hi! WarningMsg guibg={{colors.warning_container.default.hex}} guifg={{colors.on_warning_container.default.hex}}
hi! NvimInternalError guibg={{colors.danger.default.hex}} guifg={{colors.on_danger.default.hex}}

hi! CoverageCovered guifg={{colors.success.default.hex}}
hi! CoverageUncovered guifg={{colors.danger.default.hex}}
hi! CoveragePartial guifg={{colors.warning.default.hex}}

hi! DiagnosticError guifg={{colors.danger.default.hex}}
hi! DiagnosticWarn guifg={{colors.warning.default.hex}}
hi! DiagnosticInfo guifg={{colors.info.default.hex}}
hi! DiagnosticHint guifg={{colors.outline.default.hex}}
hi! DiagnosticOk guifg={{colors.success.default.hex}}

hi! RedrawDebugNormal guibg={{colors.surface_variant.default.hex}} guifg={{colors.on_surface_variant.default.hex}}
hi! RedrawDebugClear guibg={{colors.warning.default.hex}} guifg={{colors.on_warning.default.hex}}
hi! RedrawDebugComposed guibg={{colors.success.default.hex}} guifg={{colors.on_success.default.hex}}
hi! RedrawDebugRecompose guibg={{colors.danger.default.hex}} guifg={{colors.on_danger.default.hex}}

hi! DiagnosticUnderlineError gui=undercurl guisp={{colors.danger.default.hex}}
hi! DiagnosticUnderlineWarn gui=undercurl guisp={{colors.warning.default.hex}}
hi! DiagnosticUnderlineInfo gui=undercurl guisp={{colors.info.default.hex}}
hi! DiagnosticUnderlineHint gui=undercurl guisp={{colors.outline.default.hex}}
hi! DiagnosticUnderlineOk gui=undercurl guisp={{colors.success.default.hex}}
hi! DiagnosticDeprecated gui=strikethrough guisp={{colors.danger.default.hex}}

hi! SpellBad gui=undercurl guisp={{colors.success.default.hex}}
hi! SpellCap gui=undercurl guisp={{colors.success.default.hex}}
hi! SpellRare gui=undercurl guisp={{colors.success.default.hex}}
hi! SpellLocal gui=undercurl guisp={{colors.success.default.hex}}

hi! DiffAdd guibg={{colors.green_container.default.hex}} guifg={{colors.on_green_container.default.hex}}
hi! DiffChange guibg={{colors.yellow_container.default.hex}} guifg={{colors.on_yellow_container.default.hex}}
hi! DiffDelete guibg={{colors.red_container.default.hex}} guifg={{colors.on_red_container.default.hex}}
hi! DiffText guibg={{colors.blue_container.default.hex}} guifg={{colors.on_blue_container.default.hex}}

hi! NeoTreeGitAdded guifg={{colors.green.default.hex}}
hi! NeoTreeGitDeleted guifg={{colors.red.default.hex}}
hi! NeoTreeGitModified guifg={{colors.yellow.default.hex}}
hi! NeoTreeGitConflict guifg={{colors.danger.default.hex}}
hi! NeoTreeGitUntracked guifg={{colors.blue.default.hex}}

hi! NonText guifg={{colors.outline_variant.default.hex}}
hi! CursorLineNr guifg={{colors.on_surface.default.hex}}
hi! SignColumn guibg=none guifg={{colors.on_surface.default.hex}}
hi! LineNr guifg={{colors.secondary.default.hex}}

hi! IblScope guifg={{colors.on_surface.default.hex}}
hi! @ibl.scope.char.1 guifg={{colors.on_surface.default.hex}}
hi! @ibl.scope.underline.1 guisp={{colors.on_surface.default.hex}}

hi! Comment guifg={{colors.outline.default.hex}}
hi! Todo guibg={{colors.yellow_container.default.hex}} guifg={{colors.on_yellow_container.default.hex}}
hi! link @comment.todo Todo
hi! link @comment.error Error

hi! String guifg={{colors.strings.default.hex}}

hi! Identifier guifg={{colors.on_surface.default.hex}}
hi! @variable guifg={{colors.on_surface.default.hex}}
hi! Operator guifg={{colors.on_surface.default.hex}}
hi! Delimiter guifg={{colors.on_surface.default.hex}}
hi! Statement gui=bold guifg={{colors.on_surface.default.hex}}

hi! link Operator Normal
hi! link @punctuation.special @punctuation
hi! @conditional.ternary guifg={{colors.on_surface.default.hex}}
hi! link @keyword.conditional.ternary Operator
hi! link Delimiter Normal
hi! link @lsp.mod.local Normal
hi! link @parameter Identifier

hi! @lsp.mod.defaultLibrary gui=bold
hi! @lsp.mod.readonly gui=italic

hi! Constant guifg={{colors.constants.default.hex}}
hi! link @variable Constant
hi! link @variable.parameter Identifier
hi! link @lsp.typemod.variable.local Identifier
hi! link @variable.python Identifier
hi! link @variable.lua Identifier

hi! @property guifg={{colors.properties.default.hex}}
hi! link @field @property
hi! link @variable.member @property
hi! link @label.json @property
hi! link @label.jsonc @label.json
hi! link @property.typescript @property
hi! link @lsp.type.property @property
hi! link @attribute @property
hi! link @tag.attribute @property

hi! Keyword guifg={{colors.keywords.default.hex}}
hi! Special guifg={{colors.keywords.default.hex}}
hi! link Character Keyword
hi! link Boolean Keyword
hi! link Repeat Keyword
hi! link Label Keyword
hi! link Exception Keyword
hi! link Include Keyword
hi! link Conditional Keyword
hi! link @type.builtin Keyword

hi! link NotifyERRORIcon NotifyERRORBorder
hi! link NotifyWARNIcon NotifyWARNBorder
hi! link NotifyINFOIcon NotifyINFOBorder
hi! link NotifyTRACEIcon NotifyTRACEBorder
hi! link NotifyDEBUGIcon NotifyDEBUGBorder
hi! link NotifyERRORTitle NotifyERRORBorder
hi! link NotifyWARNTitle NotifyWARNBorder
hi! link NotifyINFOTitle NotifyINFOBorder
hi! link NotifyTRACETitle NotifyTRACEBorder
hi! link NotifyDEBUGTitle NotifyDEBUGBorder

hi! Number guifg={{colors.numbers.default.hex}}
hi! Function guifg={{colors.functions.default.hex}}

hi! Structure guifg={{colors.structures.default.hex}}
hi! link PreProc Structure
hi! link Tag Structure
hi! link @attribute.typescript Structure
hi! link @lsp.type.decorator Structure
hi! link @lsp.type.attributeBracket Structure
hi! link @keyword.directive.cpp PreProc
hi! link @keyword.directive.define.cpp PreProc
hi! link @keyword.import.cpp PreProc

hi! Type gui=none guifg={{colors.types.default.hex}}
hi! link @lsp.type.interface Type

hi! link AerialLine CursorLine
hi! IlluminatedWordText gui=none guibg={{colors.surface_container_highest.default.hex}}
hi! IlluminatedWordRead gui=none guibg={{colors.surface_container_highest.default.hex}}
hi! IlluminatedWordWrite gui=none guibg={{colors.surface_container_highest.default.hex}}
hi! MatchParen gui=none guibg={{colors.surface_container_highest.default.hex}}

hi! LspInlayHint gui=italic guifg={{colors.outline.default.hex}} guibg={{colors.surface_container_highest.default.hex}}

let g:lualine_theme = {
  \  "insert": {
  \    "a": {"fg": "{{colors.on_green.default.hex}}", "bg": "{{colors.green.default.hex}}", "gui": "bold"},
  \    "b": {"fg": "{{colors.on_surface_variant.default.hex}}", "bg": "{{colors.surface_variant.default.hex}}"},
  \    "c": {"fg": "{{colors.on_surface.default.hex}}", "bg": "{{colors.surface.default.hex}}"},
  \  },
  \  "normal": {
  \    "a": {"fg": "{{colors.on_primary.default.hex}}", "bg": "{{colors.primary.default.hex}}", "gui": "bold"},
  \    "b": {"fg": "{{colors.on_surface_variant.default.hex}}", "bg": "{{colors.surface_variant.default.hex}}"},
  \    "c": {"fg": "{{colors.on_surface.default.hex}}", "bg": "{{colors.surface.default.hex}}"},
  \  },
  \  "command": {
  \    "a": {"fg": "{{colors.on_tertiary.default.hex}}", "bg": "{{colors.tertiary.default.hex}}", "gui": "bold"},
  \    "b": {"fg": "{{colors.on_surface_variant.default.hex}}", "bg": "{{colors.surface_variant.default.hex}}"},
  \    "c": {"fg": "{{colors.on_surface.default.hex}}", "bg": "{{colors.surface.default.hex}}"},
  \  },
  \  "visual": {
  \    "a": {"fg": "{{colors.on_magenta.default.hex}}", "bg": "{{colors.magenta.default.hex}}", "gui": "bold"},
  \    "b": {"fg": "{{colors.on_surface_variant.default.hex}}", "bg": "{{colors.surface_variant.default.hex}}"},
  \    "c": {"fg": "{{colors.on_surface.default.hex}}", "bg": "{{colors.surface.default.hex}}"},
  \  },
  \  "replace": {
  \    "a": {"fg": "{{colors.on_red.default.hex}}", "bg": "{{colors.red.default.hex}}", "gui": "bold"},
  \    "b": {"fg": "{{colors.on_surface_variant.default.hex}}", "bg": "{{colors.surface_variant.default.hex}}"},
  \    "c": {"fg": "{{colors.on_surface.default.hex}}", "bg": "{{colors.surface.default.hex}}"},
  \  },
  \  "inactive": {
  \    "a": {"fg": "{{colors.on_surface_variant.default.hex}}", "bg": "{{colors.surface_variant.default.hex}}", "gui": "bold"},
  \    "b": {"fg": "{{colors.on_surface_variant.default.hex}}", "bg": "{{colors.surface_variant.default.hex}}"},
  \    "c": {"fg": "{{colors.on_surface_variant.default.hex}}", "bg": "{{colors.surface_variant.default.hex}}"},
  \  },
  \}
