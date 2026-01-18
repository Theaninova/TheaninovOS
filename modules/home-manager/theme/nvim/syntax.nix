# Somewhat adapted from https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/groups/syntax.lua
{ C, O }:
{
  Comment.fg = C.outline; # just comments
  SpecialComment.link = C.keywords; # special things inside a comment
  Constant.fg = C.constants; # (preferred) any constant
  String.fg = C.strings; # a string constant: "this is a string"
  Character.fg = C.keywords; # a character constant: 'c', '\n'
  Number.fg = C.numbers; # a number constant: 234, 0xff
  Float.fg = C.numbers; # a floating point constant: 2.3e10
  Boolean.fg = C.keywords; # a boolean constant: TRUE, false
  Identifier.fg = C.on_surface; # (preferred) any variable name
  Function.fg = C.functions; # function name (also: methods for classes)
  Statement.fg = C.mauve; # (preferred) any statement
  Conditional.fg = C.keywords; # if, then, else, endif, switch, etc.
  Repeat.fg = C.keywords; # for, do, while, etc.
  Label.fg = C.keywords; # case, default, etc.
  Operator.fg = C.on_surface; # "sizeof", "+", "*", etc.
  Keyword.fg = C.keywords; # any other keyword
  Exception.fg = C.keywords; # try, catch, throw

  PreProc.link = C.structures; # (preferred) generic Preprocessor
  Include.fg = C.keywords; # preprocessor #include
  Define.fg = C.keywords; # preprocessor #define
  Macro.fg = C.keywords; # same as Define
  PreCondit.fg = C.keywords; # preprocessor #if, #else, #endif, etc.

  StorageClass.fg = C.keywords; # static, register, volatile, etc.
  Structure.fg = C.structures; # struct, union, enum, etc.
  Special.fg = C.keywords; # (preferred) any special symbol
  Type.fg = C.types; # (preferred) int, long, char, etc.
  Typedef.link = "Type"; # A typedef
  SpecialChar.link = "Special"; # special character in a constant
  Tag = C.structures; # you can use CTRL-] on this
  Delimiter.fg = C.on_surface; # character that needs attention
  Debug.link = "Special"; # debugging statements

  Underlined.style = [ "underline" ]; # (preferred) text that stands out, HTML links
  Bold.style = [ "bold" ];
  Italic.style = [ "italic" ];
  # ("Ignore", below, may be invisible...)
  # Ignore = { }; # (preferred) left blank, hidden  |hl-Ignore|

  Error = {
    bg = C.danger_container; # (preferred) any erroneous construct
    fg = C.on_danger_container;
  };
  Todo = {
    bg = C.yellow_container;
    fg = C.on_yellow_container;
  }; # (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX
  qfLineNr.fg = C.yellow;
  qfFileName.fg = C.blue;
  htmlH1 = {
    fg = C.pink;
    style = [ "bold" ];
  };
  htmlH2 = {
    fg = C.blue;
    style = [ "bold" ];
  };
  # mkdHeading = { fg = C.peach; style = [ "bold" ]; };
  # mkdCode = { bg = C.terminal_black; fg = C.text; };
  mkdCodeDelimiter = {
    bg = C.base;
    fg = C.text;
  };
  mkdCodeStart = {
    fg = C.flamingo;
    style = [ "bold" ];
  };
  mkdCodeEnd = {
    fg = C.flamingo;
    style = [ "bold" ];
  };
  # mkdLink = { fg = C.blue; style = [ "underline" ]; };

  # debugging
  debugPC = {
    bg = if O.transparent_background then C.none else C.crust;
  }; # used for highlighting the current line in terminal-debug
  debugBreakpoint = {
    bg = C.base;
    fg = C.overlay0;
  }; # used for breakpoint colors in terminal-debug
  # illuminate
  illuminatedWord = {
    bg = C.surface1;
  };
  illuminatedCurWord = {
    bg = C.surface1;
  };
  # diff
  Added.fg = C.green;
  Changed.fg = C.blue;
  diffAdded.fg = C.green;
  diffRemoved.fg = C.red;
  diffChanged.fg = C.blue;
  diffOldFile.fg = C.yellow;
  diffNewFile.fg = C.peach;
  diffFile.fg = C.blue;
  diffLine.fg = C.overlay0;
  diffIndexLine.fg = C.teal;
  DiffAdd = {
    bg = U.darken C.green 0.18 C.base;
  }; # diff mode: Added line |diff.txt|
  DiffChange = {
    bg = U.darken C.blue 0.07 C.base;
  }; # diff mode: Changed line |diff.txt|
  DiffDelete = {
    bg = U.darken C.red 0.18 C.base;
  }; # diff mode: Deleted line |diff.txt|
  DiffText = {
    bg = U.darken C.blue 0.30 C.base;
  }; # diff mode: Changed text within a changed line |diff.txt|
  # NeoVim
  healthError.fg = C.red;
  healthSuccess.fg = C.teal;
  healthWarning.fg = C.yellow;
  # misc

  # glyphs
  GlyphPalette1.fg = C.red;
  GlyphPalette2.fg = C.teal;
  GlyphPalette3.fg = C.yellow;
  GlyphPalette4.fg = C.blue;
  GlyphPalette6.fg = C.teal;
  GlyphPalette7.fg = C.text;
  GlyphPalette9.fg = C.red;

  # rainbow
  rainbow1.fg = C.red;
  rainbow2.fg = C.peach;
  rainbow3.fg = C.yellow;
  rainbow4.fg = C.green;
  rainbow5.fg = C.sapphire;
  rainbow6.fg = C.lavender;

  # csv
  csvCol0.fg = C.red;
  csvCol1.fg = C.peach;
  csvCol2.fg = C.yellow;
  csvCol3.fg = C.green;
  csvCol4.fg = C.sky;
  csvCol5.fg = C.blue;
  csvCol6.fg = C.lavender;
  csvCol7.fg = C.mauve;
  csvCol8.fg = C.pink;

  # markdown
  markdownHeadingDelimiter = {
    fg = C.peach;
    style = [ "bold" ];
  };
  markdownCode.fg = C.flamingo;
  markdownCodeBlock.fg = C.flamingo;
  markdownLinkText = {
    fg = C.blue;
    style = [ "underline" ];
  };
  markdownH1.link = "rainbow1";
  markdownH2.link = "rainbow2";
  markdownH3.link = "rainbow3";
  markdownH4.link = "rainbow4";
  markdownH5.link = "rainbow5";
  markdownH6.link = "rainbow6";
}
