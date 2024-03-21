function(colors)
  return {
    CmpItemKindCopilot = { fg = colors.teal },
    CmpItemKindNpm = { fg = colors.maroon },

    -- IntelliJ Theme
    Constant = { fg = colors.mauve },
    Character = { link = "Keyword" },
    Number = { fg = colors.sapphire },
    Boolean = { link = "Keyword" },
    Identifier = { fg = colors.text },
    Function = { fg = colors.blue },
    Statement = { fg = colors.text },
    Conditional = { link = "Keyword" },
    Repeat = { link = "Keyword" },
    Label = { link = "Keyword" },
    Operator = { fg = colors.text },
    Keyword = { fg = colors.peach },
    Exception = { link = "Keyword" },
    Include = { link = "Keyword" },
    Structure = { fg = colors.yellow },
    Type = { fg = colors.teal },

    SpellBad = { sp = colors.green, style = { "underdotted" } },
    SpellCap = { sp = colors.green, style = { "underdotted" } },
    SpellLocal = { sp = colors.green, style = { "underdotted" } },
    SpellRare = { sp = colors.green, style = { "underdotted" } },

    ["@constructor"] = { link = "Keyword" },
    ["@constructor.typescript"] = { link = "@constructor" },
    ["@parameter"] = { link = "Identifier" },

    ["@tag"] = { link = "Structure" },
    ["@tag.delimiter"] = { link = "Structure" },
    ["@tag.attribute"] = { fg = colors.mauve, style = { "italic" } },     -- Constant

    ["@keyword.function"] = { link = "Keyword" },
    ["@keyword.operator"] = { link = "Keyword" },
    ["@keyword.return"] = { link = "Keyword" },
    ["@keyword.export"] = { link = "Keyword" },

    ["@punctuation.special"] = { link = "Operator" },
    ["@conditional.ternary"] = { link = "Operator" },

    ["@type.builtin"] = { link = "Keyword" },
    ["@variable.builtin"] = { link = "Keyword" },
    ["@lsp.typemod.class.defaultLibrary"] = { fg = colors.yellow, style = { "bold" } },       -- Structure
    ["@lsp.typemod.variable.defaultLibrary"] = { fg = colors.mauve, style = { "bold" } },     -- Constant
    ["@lsp.typemod.function.defaultLibrary"] = { fg = colors.blue, style = { "bold" } },      -- Function

    ["@variable"] = { link = "Constant" },
    ["@field"] = { link = "Constant" },
    ["@label.json"] = { link = "Constant" },
    ["@label.jsonc"] = { link = "Constant" },
    ["@property"] = { link = "Constant" },
    ["@property.typescript"] = { link = "@property" },
    ["@lsp.type.property"] = { link = "Constant" },
    ["@lsp.type.interface"] = { link = "Structure" },
    ["@lsp.type.namespace"] = { link = "Structure" },
    ["@attribute.typescript"] = { link = "Structure" },

    ["@lsp.mod.local"] = { fg = colors.text },
    ["@lsp.mod.readonly"] = { style = { "italic" } },
  }
end
