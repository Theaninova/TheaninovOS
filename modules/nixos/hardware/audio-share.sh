set -eu

get_id() {
  pw-dump | jq -r --arg name "$1" '
        .[]
        | select(.type == "PipeWire:Interface:Node")
        | select(.info.props["node.name"] == $name)
        | .id
    '
}

ID_A=$(get_id "$SINK_A")
ID_B=$(get_id "$SINK_B")

CURRENT_ID=$(wpctl inspect @DEFAULT_AUDIO_SINK@ |
  awk '$1 == "id" { gsub(",", "", $2); print $2 }')

if [ "$CURRENT_ID" = "$ID_A" ]; then
  wpctl set-default "$ID_B"
else
  wpctl set-default "$ID_A"
fi
