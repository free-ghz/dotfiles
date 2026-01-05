-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 80
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 16
config.font = wezterm.font_with_fallback { 'TamzenForPowerline' }

config.color_scheme = 'Birds Of Paradise (Gogh)'

-- (from https://wezterm.org/colorschemes/index.html)
-- Built-in color schemes i like:
--   Colorful:: `AlienBlood` green, maybe a bit dark
--              `Borland` blue and bright, dark theme.
--   Dark: `Andromeda` a bit poppy
--         `astromouse (terminal.sexy)` pinkish
--         `Atelier Estuary (base16)` green!
--         `Bim (Gogh)` sparkledog shit
--         `Birds Of Paradise (Gogh)` warm colors. slightly brown bg
--   Light: `Atelier Cave Light (base16)` pink-purple
--          `zenwritten_light`
--          `Belafonte Day` a little shadier with nice vibrant colors
--          `Yousai (terminal.sexy)` warm colors. eggshell bg

-- make the tab bar look terminally as well...
config.use_fancy_tab_bar = false



-- on mac which is often, i want my left alt back so i can type $[] etc with my swedish layout
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false

-- give back opt+left/right to move whole words
local act = wezterm.action

config.keys = {
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = act.SendKey {
      key = 'b',
      mods = 'ALT',
    },
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = act.SendKey { key = 'f', mods = 'ALT' },
  },
}




-- Finally, return the configuration to wezterm:
return config

