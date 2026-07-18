SCHEME=$(dconf read /org/gnome/desktop/interface/color-scheme)
if [ "$SCHEME" = "'prefer-light'" ]; then
  MODE="light"
else
  MODE="dark"
fi

if [ ! -d "$STATE" ]; then
  mkdir -p "$STATE"
fi
if [ -f "$STATE/mode" ]; then
  MODE=$(cat "$STATE/mode")
fi

if [ $# -eq 0 ]; then
  echo -e "\033[1mUsage:\033[0m mode|light|dark|auto|toggle|wallpaper"
  exit 1
elif [ "$1" = "mode" ]; then
  echo -e "$MODE"
  exit 0
elif [ "$1" = "wallpaper" ]; then
  if [ $# -eq 1 ]; then
    PICKED=$(zenity --file-selection --file-filter='Images | *.png *.jpg *.jpeg *.svg *.bmp *.gif')
  else
    dconf write /org/gnome/desktop/background/picture-uri "'file://$2'"
  fi
  dconf write /org/gnome/desktop/background/picture-uri "'file://$PICKED'"
elif [ "$1" = "wallpaper-dark" ]; then
  if [ $# -eq 1 ]; then
    PICKED=$(zenity --file-selection --file-filter='Images | *.png *.jpg *.jpeg *.svg *.bmp *.gif')
  else
    dconf write /org/gnome/desktop/background/picture-uri-dark "'file://$2'"
  fi
  dconf write /org/gnome/desktop/background/picture-uri-dark "'file://$PICKED'"
elif [ "$1" = "toggle" ]; then
  if [ "$MODE" = "light" ]; then
    MODE="dark"
  else
    MODE="light"
  fi
  echo "$MODE" >"$STATE/mode"
elif [ "$1" = "light" ] || [ "$1" = "dark" ] || [ "$1" == "auto" ]; then
  MODE="$1"
  echo "$MODE" >"$STATE/mode"
elif [ "$1" = "init" ]; then
  echo -e "\033[1mSetting up matugen\033[0m"
else
  echo -e "\033[31mInvalid argument\033[0m"
  exit 1
fi

if [ "$MODE" = "auto" ]; then
  TIME=$(sunwait poll "$LAT" "$LON" || :)
  if [ "$TIME" = "DAY" ]; then
    MODE="light"
    NEXT=6
  else
    MODE="dark"
    NEXT=4
  fi
  NEXT=$(sunwait report "$LAT" "$LON" | awk "/Daylight:/ {print \$$NEXT}")
  cat <<EOF | tee "$THEME_SERVICE_PATH" >/dev/null
[Unit]
Description=Next theme change timer

[Timer]
OnCalendar=*-*-* $(date -d "$NEXT today + 5 minutes" +'%H:%M'):00
AccuracySec=1min

[Install]
WantedBy=timers.target
EOF
else
  rm -f "$THEME_SERVICE_PATH"
fi
systemctl --user daemon-reload &>/dev/null || :
systemctl --user restart theme-init.timer &>/dev/null || :

if command -v niri &>/dev/null; then
  niri msg action do-screen-transition --delay-ms 500
fi

if [ "$MODE" = "light" ]; then
  GTK_THEME="adw-gtk3"
  WALLPAPER=$(dconf read /org/gnome/desktop/background/picture-uri | sed "s/'file:\/\///;s/'//g")
else
  GTK_THEME="adw-gtk3-dark"
  WALLPAPER=$(dconf read /org/gnome/desktop/background/picture-uri-dark | sed "s/'file:\/\///;s/'//g")
fi

if [ ! -f "$WALLPAPER" ]; then
  echo -e "\033[31,1mNo wallpaper set\033[0m"
  exit 1
fi

matugen image "$WALLPAPER" --mode "$MODE"
awww img "$WALLPAPER"

dconf write /org/gnome/desktop/interface/gtk-theme "'$GTK_THEME'"
dconf write /org/gnome/desktop/interface/color-scheme "'prefer-$MODE'"
dconf write /org/gnome/desktop/interface/icon-theme "'Tela'"
