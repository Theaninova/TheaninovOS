let
  transparent = color: "alpha(${color}, {{custom.transparency}})";
  mkBgColor = color: {
    ${color} = {
      background = "{{colors.${color}.default.hex}}";
      foreground = "{{colors.on_${color}.default.hex}}";
    };
  };
  mkColor = color: {
    ${color} = {
      standalone = "{{colors.${color}.default.hex}}";
      background = "{{colors.${color}_container.default.hex}}";
      foreground = "{{colors.on_${color}_container.default.hex}}";
    };
  };
  colors =
    (mkColor "primary")
    // (mkColor "secondary")
    // (mkColor "tertiary")
    // (mkColor "danger")
    // (mkColor "warning")
    // (mkColor "success")
    // (mkColor "error")
    // (mkColor "info")
    // (mkBgColor "background")
    // (mkBgColor "surface_variant")
    // {
      outline = "{{colors.outline.default.hex}}";
      container = {
        lowest = "{{colors.surface_container_lowest.default.hex}}";
        low = "{{colors.surface_container_low.default.hex}}";
        default = "{{colors.surface_container.default.hex}}";
        high = "{{colors.surface_container_high.default.hex}}";
        highest = "{{colors.surface_container_highest.default.hex}}";
        foreground = "{{colors.on_surface.default.hex}}";
      };
      shade = {
        default = "rgba(0, 0, 0, 0.07)";
        darker = "rgba(0, 0, 0, 0.12)";
      };
    };

  gtk = {
    accent_color = colors.primary.standalone;
    accent_bg_color = colors.primary.background;
    accent_fg_color = colors.primary.foreground;

    destructive_color = colors.danger.standalone;
    destructive_bg_color = colors.danger.background;
    destructive_fg_color = colors.danger.foreground;

    success_color = colors.success.standalone;
    success_bg_color = colors.success.background;
    success_fg_color = colors.success.foreground;

    warning_color = colors.warning.standalone;
    warning_bg_color = colors.warning.background;
    warning_fg_color = colors.warning.foreground;

    error_color = colors.error.standalone;
    error_bg_color = colors.error.background;
    error_fg_color = colors.error.foreground;

    window_bg_color = transparent colors.background.background;
    window_fg_color = colors.background.foreground;

    view_bg_color = transparent colors.background.background;
    view_fg_color = colors.background.foreground;

    headerbar_bg_color = transparent colors.background.background;
    headerbar_fg_color = colors.background.foreground;
    headerbar_border_color = colors.outline;
    headerbar_backdrop_color = transparent colors.background.background;
    headerbar_shade_color = colors.shade.default;
    headerbar_darker_shade_color = colors.shade.darker;

    card_bg_color = colors.container.default;
    card_fg_color = colors.container.foreground;
    card_shade_color = colors.shade.default;

    dialog_bg_color = transparent colors.background.background;
    dialog_fg_color = colors.background.foreground;

    popover_bg_color = transparent colors.background.background;
    popover_fg_color = colors.background.foreground;
    popover_shade_color = colors.shade.default;

    shade_color = colors.shade.default;
    scrollbar_outline_color = colors.outline;

    thumbnail_bg_color = colors.secondary.background;
    thumbnail_fg_color = colors.secondary.foreground;

    sidebar_bg_color = transparent colors.background.background;
    sidebar_fg_color = colors.background.foreground;
    sidebar_backdrop_color = transparent colors.background.background;
    sidebar_shade_color = colors.shade.default;

    secondary_sidebar_bg_color = transparent colors.surface_variant.background;
    secondary_sidebar_fg_color = colors.surface_variant.foreground;
    secondary_sidebar_backdrop_color = transparent colors.surface_variant.background;
    secondary_sidebar_shade_color = colors.shade.default;
  };
in
builtins.concatStringsSep "\n" (
  builtins.map (name: "@define-color ${name} ${builtins.getAttr name gtk};") (builtins.attrNames gtk)
)
