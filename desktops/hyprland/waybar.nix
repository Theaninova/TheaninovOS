{
  enable = true;
  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 48;
      output = "HDMI-A-1";
      modules-left = [ "wlr/workspaces" ];
      modules-center = [ "wlr/taskbar" ];
      modules-right = [ "custom/weather" "clock" ];

      "wlr/taskbar" = {
        all-outputs = true;
        format = "{icon}";
        icon-size = 32;
        on-click = "activate";
      };

      "custom/weather" = {
        format = "{}";
        tooltip = true;
        interval = 3600;
        exec = "wttrbar --location Berlin";
        return-type = "json";
      };

      "wlr/workspaces" = {
        all-outputs = true;
        format = "<sub>{icon}</sub>\n{windows}";
        format-window-separator = "\n";
        window-rewrite = {
          "(.*) — Mozilla Firefox" = "";
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
