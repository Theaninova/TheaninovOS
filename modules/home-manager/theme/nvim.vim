set background=dark

let g:neovide_transparency = {{custom.transparency}}
let g:neovide_padding_top = {{custom.padding}}
let g:neovide_padding_bottom = {{custom.padding}}
let g:neovide_padding_left = {{custom.padding}}
let g:neovide_padding_right = {{custom.padding}}
let g:neovide_floating_blur_amount_x = {{custom.blur}}
let g:neovide_floating_blur_amount_y = {{custom.blur}}
let g:neovide_floating_shadow = 0

if exists("g:neovide")
  hi Normal guibg={{colors.surface.default.hex}} guifg={{colors.on_surface.default.hex}}
  set pumblend=0
  set winblend=0
else
  hi Normal ctermbg=NONE guibg=NONE guifg={{colors.on_surface.default.hex}}
  set noshowmode
end

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

hi Pmenu ctermbg=none guibg=none guifg={{colors.on_surface.default.hex}}
hi PmenuSel guibg={{colors.primary.default.hex}} guifg={{colors.on_primary.default.hex}}
hi CursorColumn guibg={{colors.primary.default.hex}} guifg={{colors.on_primary.default.hex}}
hi CursorLine guibg={{colors.primary.default.hex}} guifg={{colors.on_primary.default.hex}}
hi WildMenu guibg={{colors.primary.default.hex}} guifg={{colors.on_primary.default.hex}}
hi MoreMsg guifg={{colors.primary.default.hex}}
hi Question guifg={{colors.secondary.default.hex}}

hi Title guifg={{colors.primary.default.hex}}
hi FloatTitle guifg={{colors.primary.default.hex}}
hi Visual guifg={{colors.on_primary.default.hex}} guibg={{colors.primary.default.hex}}

hi Folded guibg={{colors.secondary.default.hex}} guifg={{colors.on_secondary.default.hex}}
hi FoldColumn guibg={{colors.secondary.default.hex}} guifg={{colors.on_secondary.default.hex}}

hi Conceal guibg={{colors.secondary_container.default.hex}} guifg={{colors.on_secondary_container.default.hex}}

hi TabLine guibg={{colors.primary_container.default.hex}} guifg={{colors.on_primary_container.default.hex}}
hi TabLineFill guibg={{colors.primary.default.hex}} guifg={{colors.on_primary.default.hex}}

hi SpecialKey guifg={{colors.primary.default.hex}}
hi Directory guifg={{colors.primary.default.hex}}
hi Search guifg={{colors.on_tertiary.default.hex}} guibg={{colors.tertiary.default.hex}}

hi CmpItemKindCopilot guifg={{colors.cyan.default.hex}}
hi CmpItemKindNpm guifg={{colors.red.default.hex}}

hi Error guibg={{colors.danger_container.default.hex}} guifg={{colors.on_danger_container.default.hex}}
hi ErrorMsg guibg={{colors.danger_container.default.hex}} guifg={{colors.on_danger_container.default.hex}}
hi WarningMsg guibg={{colors.warning_container.default.hex}} guifg={{colors.on_warning_container.default.hex}}
hi NvimInternalError guibg={{colors.danger.default.hex}} guifg={{colors.on_danger.default.hex}}

hi DiagnosticError guifg={{colors.danger.default.hex}}
hi DiagnosticWarn guifg={{colors.warning.default.hex}}
hi DiagnosticInfo guifg={{colors.info.default.hex}}
hi DiagnosticHint guifg={{colors.outline.default.hex}}
hi DiagnosticOk guifg={{colors.success.default.hex}}

hi RedrawDebugNormal guibg={{colors.surface_variant.default.hex}} guifg={{colors.on_surface_variant.default.hex}}
hi RedrawDebugClear guibg={{colors.warning.default.hex}} guifg={{colors.on_warning.default.hex}}
hi RedrawDebugComposed guibg={{colors.success.default.hex}} guifg={{colors.on_success.default.hex}}
hi RedrawDebugRecompose guibg={{colors.danger.default.hex}} guifg={{colors.on_danger.default.hex}}

hi DiagnosticUnderlineError gui=undercurl guisp={{colors.danger.default.hex}}
hi DiagnosticUnderlineWarn gui=undercurl guisp={{colors.warning.default.hex}}
hi DiagnosticUnderlineInfo gui=undercurl guisp={{colors.info.default.hex}}
hi DiagnosticUnderlineHint gui=undercurl guisp={{colors.outline.default.hex}}
hi DiagnosticUnderlineOk gui=undercurl guisp={{colors.success.default.hex}}
hi DiagnosticDeprecated gui=strikethrough guisp={{colors.danger.default.hex}}

hi SpellBad gui=undercurl guisp={{colors.success.default.hex}}
hi SpellCap gui=undercurl guisp={{colors.success.default.hex}}
hi SpellRare gui=undercurl guisp={{colors.success.default.hex}}
hi SpellLocal gui=undercurl guisp={{colors.success.default.hex}}

hi DiffAdd guibg={{colors.green_container.default.hex}} guifg={{colors.on_green_container.default.hex}}
hi DiffChange guibg={{colors.yellow_container.default.hex}} guifg={{colors.on_yellow_container.default.hex}}
hi DiffDelete guibg={{colors.red_container.default.hex}} guifg={{colors.on_red_container.default.hex}}
hi DiffText guibg={{colors.blue_container.default.hex}} guifg={{colors.on_blue_container.default.hex}}

hi NeoTreeGitAdded guifg={{colors.green.default.hex}}
hi NeoTreeGitDeleted guifg={{colors.red.default.hex}}
hi NeoTreeGitModified guifg={{colors.yellow.default.hex}}
hi NeoTreeGitConflict guifg={{colors.danger.default.hex}}
hi NeoTreeGitUntracked guifg={{colors.blue.default.hex}}

hi NonText guifg={{colors.outline_variant.default.hex}}
hi LineNr guifg={{colors.outline_variant.default.hex}}
hi CursorLineNr guifg={{colors.on_surface.default.hex}}
hi SignColumn guibg=none guifg={{colors.on_surface.default.hex}}

hi IblScope guifg={{colors.on_surface.default.hex}}
hi @ibl.scope.char.1 guifg={{colors.on_surface.default.hex}}
hi @ibl.scope.underline.1 guisp={{colors.on_surface.default.hex}}

hi Comment guifg={{colors.outline.default.hex}}
hi Todo guibg={{colors.yellow_container.default.hex}} guifg={{colors.on_yellow_container.default.hex}}
hi def link @comment.todo Todo
hi def link @comment.error Error

hi String guifg={{colors.strings.default.hex}}

hi Identifier guifg={{colors.on_surface.default.hex}}
hi Statement gui=bold guifg={{colors.on_surface.default.hex}}
hi def link Operator Normal
hi @conditional.ternary guifg={{colors.on_surface.default.hex}}
hi def link @keyword.conditional.ternary Operator
hi def link Delimiter Normal
hi def link @lsp.mod.local Normal
hi def link @parameter Identifier

hi @lsp.mod.defaultLibrary gui=bold
hi @lsp.mod.readonly gui=italic

hi Constant guifg={{colors.constants.default.hex}}
hi def link @variable Constant

hi @property guifg={{colors.properties.default.hex}}
hi def link @field @property
hi def link @label.json @property
hi def link @label.jsonc @label.json
hi def link @property.typescript @property
hi def link @lsp.type.property @property
hi def link @attribute @property
hi def link @tag.attribute @property

hi def link @lsp.type.variable Constant
hi def link @lsp.typemod.variable.local Identifier

hi Keyword guifg={{colors.keywords.default.hex}}
hi Special guifg={{colors.keywords.default.hex}}
hi def link Character Keyword
hi def link Boolean Keyword
hi def link Repeat Keyword
hi def link Label Keyword
hi def link Exception Keyword
hi def link Include Keyword
hi def link Conditional Keyword
hi def link @type.builtin Keyword

hi Number guifg={{colors.numbers.default.hex}}
hi Function guifg={{colors.functions.default.hex}}

hi Structure guifg={{colors.structures.default.hex}}
hi def link PreProc Structure
hi def link Tag Structure
hi def link @attribute.typescript Structure

hi Type gui=none guifg={{colors.types.default.hex}}
hi def link @lsp.type.interface Type

hi IlluminatedWordText gui=none guibg={{colors.surface_container_highest.default.hex}}
hi IlluminatedWordRead gui=none guibg={{colors.surface_container_highest.default.hex}}
hi IlluminatedWordWrite gui=none guibg={{colors.surface_container_highest.default.hex}}
hi MatchParen gui=none guibg={{colors.surface_container_highest.default.hex}}

:lua require('lualine').setup({options = {theme = {
  \  insert = {
  \    a = {fg = "{{colors.on_green.default.hex}}", bg = "{{colors.green.default.hex}}", gui = "bold"},
  \    b = {fg = "{{colors.on_surface_variant.default.hex}}", bg = "{{colors.surface_variant.default.hex}}"},
  \    c = {fg = "{{colors.on_surface.default.hex}}", bg = "{{colors.surface.default.hex}}"},
  \  },
  \  normal = {
  \    a = {fg = "{{colors.on_primary.default.hex}}", bg = "{{colors.primary.default.hex}}", gui = "bold"},
  \    b = {fg = "{{colors.on_surface_variant.default.hex}}", bg = "{{colors.surface_variant.default.hex}}"},
  \    c = {fg = "{{colors.on_surface.default.hex}}", bg = "{{colors.surface.default.hex}}"},
  \  },
  \  command = {
  \    a = {fg = "{{colors.on_tertiary.default.hex}}", bg = "{{colors.tertiary.default.hex}}", gui = "bold"},
  \    b = {fg = "{{colors.on_surface_variant.default.hex}}", bg = "{{colors.surface_variant.default.hex}}"},
  \    c = {fg = "{{colors.on_surface.default.hex}}", bg = "{{colors.surface.default.hex}}"},
  \  },
  \  visual = {
  \    a = {fg = "{{colors.on_magenta.default.hex}}", bg = "{{colors.magenta.default.hex}}", gui = "bold"},
  \    b = {fg = "{{colors.on_surface_variant.default.hex}}", bg = "{{colors.surface_variant.default.hex}}"},
  \    c = {fg = "{{colors.on_surface.default.hex}}", bg = "{{colors.surface.default.hex}}"},
  \  },
  \  replace = {
  \    a = {fg = "{{colors.on_red.default.hex}}", bg = "{{colors.red.default.hex}}", gui = "bold"},
  \    b = {fg = "{{colors.on_surface_variant.default.hex}}", bg = "{{colors.surface_variant.default.hex}}"},
  \    c = {fg = "{{colors.on_surface.default.hex}}", bg = "{{colors.surface.default.hex}}"},
  \  },
  \  inactive = {
  \    a = {fg = "{{colors.on_surface_variant.default.hex}}", bg = "{{colors.surface_variant.default.hex}}", gui = "bold"},
  \    b = {fg = "{{colors.on_surface_variant.default.hex}}", bg = "{{colors.surface_variant.default.hex}}"},
  \    c = {fg = "{{colors.on_surface_variant.default.hex}}", bg = "{{colors.surface_variant.default.hex}}"},
  \  },
  \} } })

lua require('nvim-web-devicons').refresh()
