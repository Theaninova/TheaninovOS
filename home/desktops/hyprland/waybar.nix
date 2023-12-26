{pkgs}: {
  enable = true;
  settings = {
    mainBar = {
      layer = "top";
      position = "left";
      width = 16;
      modules-left = ["hyprland/workspaces"];
      modules-center = ["clock"];
      modules-right = ["custom/weather"];

      "clock" = {
        format = "<b>{%H}</b>\n{%M}";
      };

      "custom/weather" = {
        format = "{}";
        tooltip = true;
        interval = 3600;
        exec = "wttrbar --location Berlin";
        return-type = "json";
      };

      "hyprland/workspaces" = {
        format = "{windows}";
        format-window-separator = "\n";
        window-rewrite = {
          "title<.*youtube.*>" = "";
          "class<firefox>" = "";
          "title<nvim.*>" = "";
          "class<kitty>" = "";
          "class<VencordDesktop>" = "󰙯";
          "class<org.gnome.Nautilus>" = "󰝰";
        };
      };
    };
  };
  style = ''
    window#waybar {
      background: black;
    }
  '';
}
