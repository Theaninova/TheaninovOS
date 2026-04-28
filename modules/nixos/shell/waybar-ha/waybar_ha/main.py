import json
from requests import get
import keyring
import colorsys
import math


group = "waybar-ha"

HA_URL = keyring.get_password(group, "HA_URL")
HA_TOKEN = keyring.get_password(group, "HA_TOKEN")
if not HA_URL:
    keyring.set_password(group, "HA_URL", "YOUR_URL")
if not HA_TOKEN:
    keyring.set_password(group, "HA_TOKEN", "YOUR_TOKEN")

hsv_s = 0.42
hsv_v = 0.96

numbers_filled = ["󰰖", "󰲠", "󰲢", "󰲤", "󰲦", "󰲨", "󰲪", "󰲬", "󰲮", "󰲰", "󰄯", "󰰙", "󰰐"]
numbers_outline = ["󰰗", "󰲡", "󰲣", "󰲥", "󰲧", "󰲩", "󰲫", "󰲭", "󰲯", "󰲱", "󰄰", "󰰚", "󰰑"]
dots = 8


SENSORS = [
    (
        "sensor.i_9psl_carbon_dioxide",
        [
            (0, 1, 117),
            (600, 2, 100),
            (800, 3, 65),
            (1000, 4, 41),
            (1250, 5, 27),
            (1500, 6, 12),
            (1750, 7, 0),
            (1751, 7, 360),
            (2000, 8, 329),
            (3000, 8, 290),
        ],
    ),
]


def lerp(a: float, b: float, t: float) -> float:
    return (1 - t) * a + t * b


def main() -> None:
    states = get(
        f"{HA_URL}/api/states",
        headers={
            "Authorization": f"Bearer {HA_TOKEN}",
            "Content-Type": "application/json",
        },
    ).json()

    text = ""
    states_idx = {s["entity_id"]: s for s in states}
    for sensor, thresholds in SENSORS:
        if sensor not in states_idx:
            continue
        state = states_idx[sensor]
        state_icon = 1
        state_color = ""
        sensor_value = int(state["state"])

        if thresholds is not None:
            try:
                for i, (threshold, icon, hue) in reversed(list(enumerate(thresholds))):
                    if sensor_value >= threshold:
                        if sensor_value != threshold and i < len(thresholds) - 1:
                            next_threshold, _, next_hue = SENSORS[0][1][i + 1]
                            hue = lerp(
                                hue,
                                next_hue,
                                (sensor_value - threshold)
                                / (next_threshold - threshold),
                            )

                        state_icon = icon
                        state_color = "#{:02x}{:02x}{:02x}".format(
                            *(
                                int(c * 255)
                                for c in colorsys.hsv_to_rgb(hue / 360, hsv_s, hsv_v)
                            )
                        )
                        break
            except ValueError:
                pass

        suffix = []  # [11, 11, 12]
        digits: list[int] = list(map(lambda x: int(x), list(f"{sensor_value}")))
        s = "".join(
            map(
                lambda t: (
                    numbers_outline[t[1]]
                    if dots - t[0] > state_icon
                    else numbers_filled[t[1]]
                ),
                enumerate(
                    [
                        *map(lambda _: 10, range(dots - len(digits) - len(suffix))),
                        *digits,
                        *suffix,
                    ]
                ),
            )
        )
        text += f'<span color="{state_color}">{s}</span>'

    print(json.dumps({"text": text}))
