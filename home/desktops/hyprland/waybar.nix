{pkgs}: {
  enable = true;
  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      modules-left = ["hyprland/workspaces"];
      modules-center = ["clock"];
      modules-right = ["tray" "group/power"];

      "clock" = {
        format = "{:%H:%M}";
      };

      "custom/weather" = {
        format = "{}";
        tooltip = true;
        interval = 3600;
        exec = "${pkgs.wttrbar}/bin/wttrbar --location Berlin --custom-indicator \"{ICON}{temp_C}°\"";
        return-type = "json";
      };

      "group/power" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 500;
          children-class = "not-power";
          transition-left-to-right = false;
        };
        modules = [
          "custom/launcher"
          "custom/power"
          #"custom/quit"
          #"custom/lock"
          "custom/reboot"
        ];
      };

      "custom/launcher" = {
        format = " ";
        tooltip = false;
        on-click = "anyrun";
      };

      "custom/quit" = {
        format = "󰗼 ";
        tooltip = false;
        on-click = "hyprctl dispatch exit";
      };
      "custom/lock" = {
        format = "󰍁 ";
        tooltip = false;
        on-click = "swaylock";
      };
      "custom/reboot" = {
        format = "󰜉 ";
        tooltip = false;
        on-click = "reboot";
      };
      "custom/power" = {
        format = " ";
        tooltip = false;
        on-click = "shutdown now";
      };

      "hyprland/workspaces" = {
        format = "{windows}";
        format-window-separator = " ";
        window-rewrite-default = "";
        window-rewrite = {
          "title<.*youtube.*>" = "";
          "title<nvim.*>" = "";
          "title<htop.*>" = "";
          "title<p?npm.*>" = "󰢩";
          "class<firefox>" = "";
          "class<chromium-browser>" = "";
          "class<lutris>" = "󰺵";
          "class<.gimp.*>" = "";
          "class<org.inkscape.Inkscape>" = "";
          "class<kitty>" = "󰆍";
          "class<blender>" = "󰂫";
          "class<steam>" = "󰓓";
          "class<libreoffice.*>" = "󰏆";
          "class<Element>" = "󰭹";
          "class<brave-browser>" = "";
          "class<Jellyfin Media Player>" = "󰼁";
          "class<VencordDesktop>" = "󰙯";
          "class<org.gnome.Nautilus>" = "󰝰";
        };
      };
    };
  };
  style =
    /*
    css
    */
    ''
      * {
        font-weight: bold;
      }

        window#waybar {
          background: black;
        }

        #workspaces {
        }

        #workspaces button {
          opacity: 0.5;
          padding: 0;
          border-radius: 0;
          border-width: 0;
          font-size: 16px;
          padding-left: 2px;
          padding-right: 2px;
          border-top: 2px solid transparent;
          transition: all 250ms ease;
        }

        #workspaces button.active {
          opacity: 1;
        }

        #workspaces button.visible {
          border-top-color: currentcolor;
        }
    '';
}
