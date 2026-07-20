# Starter item icons

These 256×256 RGBA PNGs are the reviewed starter-item artwork used by the packaged inventory NUI.

| Server `icon_key` | Asset |
| --- | --- |
| `water_bottle` | `water_bottle.png` |
| `sandwich` | `sandwich.png` |
| `state_id` | `state_id.png` |
| `city_tablet` | `city_tablet.png` |

The images use a shared semi-realistic navy-and-gold game-item style, contain no brands or readable personal data, and were generated specifically for this project. The Tablet artwork represents the character-bound City Tablet that launches approved applications. Unknown or unavailable image keys retain the deterministic two-letter UI fallback.

New definitions must receive a stable server-owned `icon_key`; adding artwork never changes inventory authority or accepts an asset path from the client.
