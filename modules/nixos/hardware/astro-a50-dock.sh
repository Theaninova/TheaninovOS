stdbuf -oL hexdump -v -e '32/2 "%x " "\n"' "$HID_DEVICE" | while read -r line; do
  echo "$line"
  if [[ $line =~ ^c02[[:space:]]4[[:space:]]13[[:space:]]([0-9a-f]+) ]]; then
    power_state=${BASH_REMATCH[1]}
    if [[ $power_state == "0" ]]; then
      echo "power=on"
      wpctl set-default "$(pw-cli info "$HEADSET_NAME" | head -n 1 | awk '{print $2}')"
    else
      echo "power=off"
      wpctl set-default "$(pw-cli info "$SPEAKERS_NAME" | head -n 1 | awk '{print $2}')"
    fi
  fi
done
