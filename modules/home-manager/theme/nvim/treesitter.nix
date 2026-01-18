{ C, O }:
let
  self = {
    # Reference: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md
    # Identifiers
    "@variable".fg = C.on_surface; # Any variable name that does not have another highlight.
    "@variable.builtin".fg = C.keywords; # Variable names that are defined by the languages, like this or self.
    "@variable.parameter".fg = C.on_surface; # For parameters of a function.
    "@variable.member".fg = C.properties; # For fields.

    "@constant".fg = C.constants; # For constants
    "@constant.builtin".fg = C.keywords; # For constant that are built in the language: nil in Lua.
    "@constant.macro".link = "Macro"; # For constants that are defined by macros: NULL in C.

    "@module".fg = C.structures; # For identifiers referring to modules and namespaces.
    "@label".link = "Label"; # For labels: label: in C and :label: in Lua.

    # Literals
    "@string".link = "String"; # For strings.
    /*
        "@string.documentation" = {
          fg = C.teal;
          style = O.styles.strings or { };
        }; # For strings documenting code (e.g. Python docstrings).
        "@string.regexp" = {
          fg = C.pink;
          style = O.styles.strings or { };
        }; # For regexes.
        "@string.escape" = {
          fg = C.pink;
          style = O.styles.strings or { };
        }; # For escape characters within a string.
        "@string.special".link = "Special"; # other special strings (e.g. dates)
        "@string.special.path".link = "Special"; # filenames
        "@string.special.symbol".fg = C.flamingo; # symbols or atoms
        "@string.special.url" = {
          fg = C.blue;
          style = [
            "italic"
            "underline"
          ];
        }; # urls, links and emails
      "@punctuation.delimiter.regex" = {
        link = "@string.regexp";
      };
    */

    "@character".link = "Character"; # character literals
    "@character.special".link = "SpecialChar"; # special characters (e.g. wildcards)

    "@boolean".link = "Boolean"; # For booleans.
    "@number".link = "Number"; # For all numbers
    "@number.float".link = "Float"; # For floats.

    # Types
    "@type".link = "Type"; # For types.
    "@type.builtin".fg = C.keywords; # For builtin types.
    "@type.definition".link = "Type"; # type definitions (e.g. `typedef` in C)

    "@attribute".fg = C.properties; # attribute annotations (e.g. Python decorators)
    "@property".fg = C.properties; # fields, like accessing `bar` property on `foo.bar`. Overriden later for data languages and CSS.

    # Functions
    "@function".link = "Function"; # For function (calls and definitions).
    "@function.builtin" = {
      fg = C.functions;
      style = [ "bold" ];
    }; # For builtin functions: table.insert in Lua.
    "@function.call".link = "Function"; # function calls
    "@function.macro".link = "Macro"; # For macro defined functions (calls and definitions): each macro_rules in Rust.

    "@function.method".link = "Function"; # For method definitions.
    "@function.method.call".link = "Function"; # For method calls.

    "@constructor" = {
      fg = C.yellow;
    }; # For constructor calls and definitions: = { } in Lua, and Java constructors.
    "@operator" = {
      link = "Operator";
    }; # For any operator: +, but also -> and * in C.

    # Keywords
    "@keyword".link = "Keyword"; # For keywords that don't fall in previous categories.
    "@keyword.modifier".link = "Keyword"; # For keywords modifying other constructs (e.g. `const`, `static`, `public`)
    "@keyword.type".link = "Keyword"; # For keywords describing composite types (e.g. `struct`, `enum`)
    "@keyword.coroutine".link = "Keyword"; # For keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
    "@keyword.function" = {
      fg = C.mauve;
      style = O.styles.keywords or { };
    }; # For keywords used to define a function.
    "@keyword.operator" = {
      fg = C.mauve;
      style = O.styles.keywords or { };
    }; # For new keyword operator
    "@keyword.import" = {
      link = "Include";
    }; # For includes: #include in C, use or extern crate in Rust, or require in Lua.
    "@keyword.repeat" = {
      link = "Repeat";
    }; # For keywords related to loops.
    "@keyword.return" = {
      fg = C.mauve;
      style = O.styles.keywords or { };
    };
    "@keyword.debug".link = "Exception"; # For keywords related to debugging
    "@keyword.exception".link = "Exception"; # For exception related keywords.

    "@keyword.conditional".link = "Conditional"; # For keywords related to conditionals.
    "@keyword.conditional.ternary".link = "Operator"; # For ternary operators (e.g. `?` / `:`)

    "@keyword.directive".link = "PreProc"; # various preprocessor directives & shebangs
    "@keyword.directive.define".link = "Define"; # preprocessor definition directives
    "@keyword.export" = {
      fg = C.mauve;
      style = O.styles.keywords;
    }; # JS & derivative

    # Punctuation
    "@punctuation.delimiter".link = "Delimiter"; # For delimiters (e.g. `;` / `.` / `,`).
    "@punctuation.bracket".fg = C.overlay2; # For brackets and parenthesis.
    "@punctuation.special".link = "Special"; # For special punctuation that does not fall in the categories before (e.g. `{}` in string interpolation).

    # Comment
    "@comment".link = "Comment";
    "@comment.documentation".link = "Comment"; # For comments documenting code

    "@comment.error" = {
      fg = C.base;
      bg = C.red;
    };
    "@comment.warning" = {
      fg = C.base;
      bg = C.yellow;
    };
    "@comment.hint" = {
      fg = C.base;
      bg = C.blue;
    };
    "@comment.todo" = {
      fg = C.base;
      bg = C.flamingo;
    };
    "@comment.note" = {
      fg = C.base;
      bg = C.rosewater;
    };

    # Markup
    "@markup" = {
      fg = C.text;
    }; # For strings considerated text in a markup language.
    "@markup.strong" = {
      fg = C.red;
      style = [ "bold" ];
    }; # bold
    "@markup.italic" = {
      fg = C.red;
      style = [ "italic" ];
    }; # italic
    "@markup.strikethrough" = {
      fg = C.text;
      style = [ "strikethrough" ];
    }; # strikethrough text
    "@markup.underline" = {
      link = "Underlined";
    }; # underlined text

    "@markup.heading".fg = C.blue; # titles like: # Example
    "@markup.heading.markdown".style = [ "bold" ]; # bold headings in markdown, but not in HTML or other markup

    "@markup.math".fg = C.blue; # math environments (e.g. `$ ... $` in LaTeX)
    "@markup.quote".fg = C.pink; # block quotes
    "@markup.environment".fg = C.pink; # text environments of markup languages
    "@markup.environment.name".fg = C.blue; # text indicating the type of an environment

    "@markup.link".fg = C.lavender; # text references, footnotes, citations, etc.
    "@markup.link.label".fg = C.lavender; # link, reference descriptions
    "@markup.link.url" = {
      fg = C.blue;
      style = [
        "italic"
        "underline"
      ];
    }; # urls, links and emails

    "@markup.raw" = {
      fg = C.green;
    }; # used for inline code in markdown and for doc in python (""")

    "@markup.list" = {
      fg = C.teal;
    };
    "@markup.list.checked" = {
      fg = C.green;
    }; # todo notes
    "@markup.list.unchecked" = {
      fg = C.overlay1;
    }; # todo notes

    # Diff
    "@diff.plus" = {
      link = "diffAdded";
    }; # added text (for diff files)
    "@diff.minus" = {
      link = "diffRemoved";
    }; # deleted text (for diff files)
    "@diff.delta" = {
      link = "diffChanged";
    }; # deleted text (for diff files)

    # Tags
    "@tag" = {
      fg = C.blue;
    }; # Tags like HTML tag names.
    "@tag.builtin" = {
      fg = C.blue;
    }; # JSX tag names.
    "@tag.attribute" = {
      fg = C.yellow;
      style = O.styles.miscs or [ "italic" ];
    }; # XML/HTML attributes (foo in foo="bar").
    "@tag.delimiter" = {
      fg = C.teal;
    }; # Tag delimiter like < > /

    # Misc
    "@error" = {
      link = "Error";
    };

    # Language specific:
    "@function.builtin.bash" = {
      fg = C.red;
      style = O.styles.miscs or [ "italic" ];
    };
    "@variable.parameter.bash" = {
      fg = C.green;
    };

    "@markup.heading.1.markdown".link = "rainbow1";
    "@markup.heading.2.markdown".link = "rainbow2";
    "@markup.heading.3.markdown".link = "rainbow3";
    "@markup.heading.4.markdown".link = "rainbow4";
    "@markup.heading.5.markdown".link = "rainbow5";
    "@markup.heading.6.markdown".link = "rainbow6";

    "@markup.heading.html" = {
      link = "@markup";
    };
    "@markup.heading.1.html" = {
      link = "@markup";
    };
    "@markup.heading.2.html" = {
      link = "@markup";
    };
    "@markup.heading.3.html" = {
      link = "@markup";
    };
    "@markup.heading.4.html" = {
      link = "@markup";
    };
    "@markup.heading.5.html" = {
      link = "@markup";
    };
    "@markup.heading.6.html" = {
      link = "@markup";
    };

    "@constant.java" = {
      fg = C.teal;
    };

    "@property.css" = {
      fg = C.blue;
    };
    "@property.scss" = {
      fg = C.blue;
    };
    "@property.id.css" = {
      fg = C.yellow;
    };
    "@property.class.css" = {
      fg = C.yellow;
    };
    "@type.css" = {
      fg = C.lavender;
    };
    "@type.tag.css" = {
      fg = C.blue;
    };
    "@string.plain.css" = {
      fg = C.text;
    };
    "@number.css" = {
      fg = C.peach;
    };
    "@keyword.directive.css" = {
      link = "Keyword";
    }; # CSS at-rules

    "@string.special.url.html" = {
      fg = C.green;
    }; # Links in href, src attributes.
    "@markup.link.label.html" = {
      fg = C.text;
    }; # Text between <a></a> tags.
    "@character.special.html" = {
      fg = C.red;
    }; # Symbols such as &nbsp;.

    "@constructor.lua" = {
      link = "@punctuation.bracket";
    }; # For constructor calls and definitions: = { } in Lua.
    "@constructor.python" = {
      fg = C.sky;
    }; # __init__(), __new__().
    "@label.yaml" = {
      fg = C.yellow;
    }; # Anchor and alias names.
    "@string.special.symbol.ruby" = {
      fg = C.flamingo;
    };

    "@function.method.php" = {
      link = "Function";
    };
    "@function.method.call.php" = {
      link = "Function";
    };

    "@keyword.import.c" = {
      fg = C.yellow;
    };
    "@keyword.import.cpp" = {
      fg = C.yellow;
    };
    "@attribute.c_sharp" = {
      fg = C.yellow;
    };
    "@comment.warning.gitcommit" = {
      fg = C.yellow;
    };
    "@string.special.path.gitignore" = {
      fg = C.text;
    };

    gitcommitSummary = {
      fg = C.rosewater;
      style = O.styles.miscs or [ "italic" ];
    };
    zshKSHFunction = {
      link = "Function";
    };

    # Legacy highlights
    "@parameter" = self."@variable.parameter";
    "@field" = self."@variable.member";
    "@namespace" = self."@module";
    "@float" = self."@number.float";
    "@symbol" = self."@string.special.symbol";
    "@string.regex" = self."@string.regexp";

    "@text" = self."@markup";
    "@text.strong" = self."@markup.strong";
    "@text.emphasis" = self."@markup.italic";
    "@text.underline" = self."@markup.underline";
    "@text.strike" = self."@markup.strikethrough";
    "@text.uri" = self."@markup.link.url";
    "@text.math" = self."@markup.math";
    "@text.environment" = self."@markup.environment";
    "@text.environment.name" = self."@markup.environment.name";

    "@text.title" = self."@markup.heading";
    "@text.literal" = self."@markup.raw";
    "@text.reference" = self."@markup.link";

    "@text.todo.checked" = self."@markup.list.checked";
    "@text.todo.unchecked" = self."@markup.list.unchecked";

    "@text.todo" = self."@comment.todo";
    "@text.warning" = self."@comment.warning";
    "@text.note" = self."@comment.note";
    "@text.danger" = self."@comment.error";

    "@method" = self."@function.method";
    "@method.call" = self."@function.method.call";

    "@text.diff.add" = self."@diff.plus";
    "@text.diff.delete" = self."@diff.minus";

    "@type.qualifier" = self."@keyword.modifier";
    "@keyword.storage" = self."@keyword.modifier";
    "@define" = self."@keyword.directive.define";
    "@preproc" = self."@keyword.directive";
    "@storageclass" = self."@keyword.storage";
    "@conditional" = self."@keyword.conditional";
    "@exception" = self."@keyword.exception";
    "@include" = self."@keyword.import";
    "@repeat" = self."@keyword.repeat";

    "@symbol.ruby" = self."@string.special.symbol.ruby";
    "@variable.member.yaml" = self."@field.yaml";

    "@text.title.1.markdown" = self."@markup.heading.1.markdown";
    "@text.title.2.markdown" = self."@markup.heading.2.markdown";
    "@text.title.3.markdown" = self."@markup.heading.3.markdown";
    "@text.title.4.markdown" = self."@markup.heading.4.markdown";
    "@text.title.5.markdown" = self."@markup.heading.5.markdown";
    "@text.title.6.markdown" = self."@markup.heading.6.markdown";

    "@method.php" = self."@function.method.php";
    "@method.call.php" = self."@function.method.call.php";
  };
in
self
