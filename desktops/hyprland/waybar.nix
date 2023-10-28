{
  enable = true;
  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 48;
      output = "HDMI-A-1";
      modules-center = [ "wlr/taskbar" ];
      modules-right = [ "custom/weather" "clock" ];

      "wlr/taskbar" = {
        all-outputs = true;
      };

      "custom/weather" = {
        format = "{}";
        tooltip = true;
        interval = 3600;
        exec = "wttrbar --location Berlin";
        return-type = "json";
      };
    };
  };
  style = ''
    window#waybar {
      background: black;
    }
  '';
}
