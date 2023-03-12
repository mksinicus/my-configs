local wezterm = require 'wezterm'


-- The powerline < symbol
local LEFT_ARROW = utf8.char(0xe0b3)
-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

wezterm.on('update-status', function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  function urlDecode(s)
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
  end
  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    cwd_uri = cwd_uri:sub(8)
    local slash = cwd_uri:find '/'
    local cwd = ''
    local hostname = ''
    if slash then
      hostname = cwd_uri:sub(1, slash - 1)
      -- Remove the domain name portion of the hostname
      local dot = hostname:find '[.]'
      if dot then
        hostname = hostname:sub(1, dot - 1)
      end
      -- and extract the cwd from the uri
      -- cwd = cwd_uri:sub(slash)
      -- Handle the url-encoded uri
      cwd = urlDecode(cwd_uri:sub(slash))

      -- Handle extra long dirnames. Currently buggy?
      local basename_len = cwd:reverse():find('/')
      local CWD_MAX_LEN = 26

      -- Displays the current dir anyway
      if basename_len > CWD_MAX_LEN then
        -- 'Tis buggy
        -- cwd = '...' .. wezterm.truncate_left(cwd, #cwd - basename_len + 2)
        cwd = '...' .. cwd:sub(#cwd - basename_len + 1)
      -- Truncate, based on max length
      elseif #cwd > CWD_MAX_LEN then
        -- cwd = cwd:reverse():sub(slash)
        cwd = wezterm.truncate_left(cwd, CWD_MAX_LEN)
        local slash = cwd:find '/'
        cwd = '...' .. cwd:sub(slash)
      end

      table.insert(cells, cwd)
      -- Currently I don't need this
      -- table.insert(cells, hostname)
    end
  end

  -- I like my date/time in this style: "Wed Mar 3 08:14"
  local date = wezterm.strftime '%Y-%m-%d %a %H:%M'
  table.insert(cells, date)

  -- An entry for each battery (typically 0 or 1 battery)
  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
  end

  -- Color palette for the backgrounds of each cell
  local colors = {
    -- '#073642',
    '#0a5061',
    '#0d6d82',
    '#1190aa',
    -- '#b491c8',
  }

  -- Foreground color for the text across the fade
  local text_fg = '#fdf6e3'

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, { Foreground = { Color = colors[cell_no] } })
    table.insert(elements, { Text = SOLID_LEFT_ARROW })
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Background = { Color = colors[cell_no] } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
    -- if not is_last then
      -- table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
      -- table.insert(elements, { Text = SOLID_LEFT_ARROW })
    -- end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end)


-- # Causes significant lag on hover
-- wezterm.on(
--   'format-tab-title',
--   function(tab, tabs, panes, config, hover, max_width)
--     local edge_background = '#073642'
--     local background = '#657b83'
--     local foreground = '#073642'

--     if tab.is_active then
--       background = '#859900'
--       -- foreground = '#073642'
--     elseif hover then
--       background = '#a9bf00'
--       -- foreground = '#909090'
--     end

--     local edge_foreground = background

--     -- ensure that the titles fit in the available space,
--     -- and that we have room for the edges.
--     local title = wezterm.truncate_right(tab.active_pane.title, max_width - 2)
--     local cwd = tab.active_pane.current_working_dir

--     -- Handle extra long dirnames
--     local basename_len = cwd:reverse():find('/')
--     cwd = wezterm.truncate_left(cwd, basename_len - 1)
--     cwd = wezterm.truncate_right(cwd, max_width - 5)

--     return {
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = SOLID_LEFT_ARROW },
--       { Background = { Color = background } },
--       { Foreground = { Color = foreground } },
--       { Text = (tab.tab_index + 1) .. '. ' .. cwd },
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = SOLID_RIGHT_ARROW },
--     }
--   end
-- )

return {
  window_background_opacity = 0.93,
  use_fancy_tab_bar = false,
  tab_max_width = 18,

  -- # Color scheme and font style
  -- color_scheme = "Solarized Light (base16)",
  color_scheme = "Solarized (light) (terminal.sexy)",
  colors = {
    scrollbar_thumb = '#676350',

    tab_bar = {
      background = '#073642',
      active_tab = {
        bg_color = '#859900',
        fg_color = '#fdf6e3',
        intensity = 'Bold',
        -- italic = true
      },
      inactive_tab = {
        bg_color = '#657b83',
        fg_color = '#073642',
        intensity = 'Bold',
      },
      inactive_tab_hover = {
        bg_color = '#a9bf00',
        fg_color = '#073642',
        intensity = 'Bold'
      },
      new_tab = {
        bg_color = '#073642',
        fg_color = '#cfc7a2',
        intensity = 'Bold',
      },
      new_tab_hover = {
        bg_color = '#a9bf00',
        fg_color = '#fdf6e3',
        intensity = 'Bold',
        -- intensity = 'Bold',
        -- italic = true
      },
    }
  },

  -- # Font configuration
  -- font = wezterm.font 'Sarasa Term SC Nerd',
  font = wezterm.font_with_fallback {
    'Sarasa Term SC Nerd',
    'STIX Two Math',
    'HanaMinB',
    "Noto Sans Devanagari",
    "Noto Sans Arabic",
    "Noto Sans Hebrew",
    -- 'Unifont',
  },
  font_size = 13.8, -- ugly but it's optimal
  -- line_height = 1.08,
  window_frame = {
    font = wezterm.font_with_fallback {
      'Sarasa Term SC Nerd',
      "Noto Sans CJK SC",
      -- 'STIX Two Text'
    },
    -- font_rules = {
    --   {
    --     intensity = 'Bold',
    --     italic = false,
    --     font = wezterm.font_with_fallback(
    --       'Operator Mono SSm Lig'
    --     ),
    --   }
    -- },
    font_size = 13.8,
    -- Taken from Zellij, yay!
    
    active_titlebar_bg = '#073642',
  },
  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.9,
  },
  scrollback_lines = 10000,
  enable_scroll_bar = true,
}
