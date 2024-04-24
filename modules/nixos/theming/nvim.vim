if exists(g:neovide)
  hi Normal guibg={{colors.surface.default.hex}} guifg={{colors.on_surface.default.hex}}
	set pumblend=100
else
  hi Normal ctermbg=NONE guibg=NONE guifg={{colors.on_surface.default.hex}}
  set noshowmode
end

hi CmpItemKindCopilot guifg={{colors.cyan.default.hex}}
hi CmpItemKindNpm guifg={{colors.red.default.hex}}

hi Error guibg={{colors.error_container.default.hex}} guifg={{colors.on_error_container.default.hex}}
hi ErrorMsg guibg={{colors.error_container.default.hex}} guifg={{colors.on_error_container.default.hex}}

hi DiagnosticError guifg={{colors.error.default.hex}}
hi DiagnosticWarn guifg={{colors.warn.default.hex}}
hi DiagnosticInfo guifg={{colors.blue.default.hex}}
hi DiagnosticHint guifg={{colors.outline.default.hex}}
hi DiagnosticOk guifg={{colors.ok.default.hex}}

hi DiagnosticUnderlineError gui=undercurl guisp={{colors.error.default.hex}}
hi DiagnosticUnderlineWarn gui=undercurl guisp={{colors.warn.default.hex}}
hi DiagnosticUnderlineInfo gui=undercurl guisp={{colors.blue.default.hex}}
hi DiagnosticUnderlineHint gui=undercurl guisp={{colors.outline.default.hex}}
hi DiagnosticUnderlineOk gui=undercurl guisp={{colors.ok.default.hex}}
hi DiagnosticDeprecated gui=strikethrough guisp={{colors.error.default.hex}}

hi NonText guifg={{colors.outline_variant.default.hex}}
hi LineNr guifg={{colors.outline_variant.default.hex}}
hi CursorLineNr guifg={{colors.on_surface.default.hex}}
hi CursorColumn guifg={{colors.on_surface.default.hex}}
hi CursorLine guifg={{colors.on_surface.default.hex}}
hi SignColumn guibg=none guifg={{colors.on_surface.default.hex}}

hi IblScope guifg={{colors.on_surface.default.hex}}
hi @ibl.scope.char.1 guifg={{colors.on_surface.default.hex}}
hi @ibl.scope.underline.1 guisp={{colors.on_surface.default.hex}}

hi Comment guifg={{colors.outline.default.hex}}
hi Todo guibg={{colors.yellow_container.default.hex}} guifg={{colors.on_yellow_container.default.hex}}
hi def link @comment.todo Todo
hi def link @comment.error Error

hi String guifg={{colors.green.default.hex}}

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

hi Constant guifg={{colors.magenta.default.hex}}
hi def link @variable Constant
hi def link @field Constant
hi def link @property @field
hi def link @label.json @property
hi def link @label.jsonc @label.json
hi def link @property.typescript @property
hi def link @lsp.type.property @property

hi def link @lsp.type.variable Constant
hi def link @lsp.typemod.variable.local Identifier

hi Keyword guifg={{colors.orange.default.hex}}
hi Special guifg={{colors.orange.default.hex}}
hi def link Character Keyword
hi def link Boolean Keyword
hi def link Repeat Keyword
hi def link Label Keyword
hi def link Exception Keyword
hi def link Include Keyword
hi def link Conditional Keyword
hi def link @type.builtin Keyword

hi Number guifg={{colors.cyan.default.hex}}
hi Function guifg={{colors.cyan.default.hex}}

hi @attribute guifg={{colors.yellow.default.hex}}
hi Structure guifg={{colors.yellow.default.hex}}
hi def link PreProc Structure
hi def link Tag Structure
hi Type gui=none guifg={{colors.blue.default.hex}}
hi def link @lsp.type.interface Type

hi IlluminatedWordText gui=none guibg={{colors.surface_container_highest.default.hex}}
hi IlluminatedWordRead gui=none guibg={{colors.surface_container_highest.default.hex}}
hi IlluminatedWordWrite gui=none guibg={{colors.surface_container_highest.default.hex}}
hi MatchParen gui=none guibg={{colors.surface_container_highest.default.hex}}

hi Visual gui=bold guifg={{colors.on_primary.default.hex}} guibg={{colors.primary.default.hex}}
