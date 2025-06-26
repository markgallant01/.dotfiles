-- If LuaRocks is installed, make sure that packages installed through 
-- it are found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
--require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back 
-- to another config (This code will only ever execute for the fallback 
-- config)
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
                   title = "Oops, there were errors during startup!",
                   text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, an error happened!",
                     text = tostring(err) })
    in_error = false
  end)
end

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
local theme = gears.filesystem.get_xdg_config_home() ..
  'awesome/seasonal_theme.lua'
beautiful.init(theme)

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or
-- other tools. However, you can use another modifier like Mod1,
-- but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}

-- {{{ Wibar
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end)
)

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes
-- (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
--  set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6" },
    s, awful.layout.layouts[1]
  )

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags
  }

  -- Create a systray widget
  s.mysystray = wibox.widget.systray()

  -- Create a textclock widget
  s.mytextclock = wibox.widget.textclock("%_I:%M%P")
  s.textdate = wibox.widget.textclock("%_d %b, %Y")

  -- Create an imagebox widget which will contain an icon indicating
  -- which layout we're using. We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end)
  ))

  -- Create the wibox
--[[  s.mywibox = awful.wibar({ position = "top", screen = s })
  s.mywibox.border_width = 0
  s.mywibox.border_color = "#ffffff00"
  s.mywibox.opacity = 1
--]]
  local left_panel = wibox.widget({
    s.mytaglist,
    s.mylayoutbox,
    layout = wibox.layout.align.horizontal
  })
  left_panel.opacity = 1

  local middle_panel = wibox.widget {
    s.textdate,
    layout = wibox.layout.align.horizontal
  }

  local right_panel = wibox.widget {
    s.mysystray,
    s.mytextclock,
    layout = wibox.layout.align.horizontal
  }

  -- Add widgets to the wibox
  --s.mywibox:setup(left_panel)
  s.leeeyout = wibox.layout.align.horizontal()
  s.leeeyout.expand = 'none'
  s.leeeyout.first = left_panel
  s.leeeyout.second = middle_panel
  s.leeeyout.third = right_panel
--  s.mywibox.widget = s.leeeyout

end)
-- helper function centers mouse on client window
local function centerMouseOnClient(c)
  mouse.coords {
    x = c.x + (c.width / 2),
    y = c.y + (c.height / 2)
  }
end

-- {{{ Keybindings
globalkeys = gears.table.join(
  awful.key({ modkey }, "s", hotkeys_popup.show_help,
    {description="show help", group="awesome"}
  ),

  awful.key({ modkey }, "j",
    function ()
      awful.client.focus.byidx(1)
      local c = client.focus
      if c then
        centerMouseOnClient(c)
      end
    end,
    {description = "focus next by index", group = "client"}
  ),

  awful.key({ modkey }, "k",
    function ()
      awful.client.focus.byidx(-1)
      local c = client.focus
      if c then
        centerMouseOnClient(c)
      end
    end,
    {description = "focus previous by index", group = "client"}
  ),

  -- Layout manipulation
  awful.key({ modkey, "Shift" }, "j",
    function ()
      awful.client.swap.byidx(1)
    end,
    {description = "swap with next client by index", group = "client"}
  ),

  awful.key({ modkey, "Shift" }, "k",
    function ()
      awful.client.swap.byidx(-1)
    end,
    {
      description = "swap with previous client by index",
      group = "client"
    }
  ),

  awful.key({ modkey }, "u", awful.client.urgent.jumpto,
    {description = "jump to urgent client", group = "client"}
  ),

  -- Standard program
  awful.key({ modkey }, "Return",
    function ()
      awful.spawn(terminal)
    end,
    {description = "open a terminal", group = "launcher"}
  ),

  awful.key({ modkey, "Control" }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}
  ),

  awful.key({ modkey, "Control" }, "q", awesome.quit,
    {description = "quit awesome", group = "awesome"}
  ),

  awful.key({ modkey }, "l",
    function ()
      awful.tag.incmwfact(0.05)
    end,
    {description = "increase master width factor", group = "layout"}
  ),

  awful.key({ modkey }, "h",
    function ()
      awful.tag.incmwfact(-0.05)
    end,
    {description = "decrease master width factor", group = "layout"}
  ),

  awful.key({ modkey }, "i",
    function ()
      awful.tag.incnmaster(1, nil, true)
    end,
    {
      description = "increase the number of master clients",
      group = "layout"
    }
  ),

  awful.key({ modkey }, "d",
    function ()
      awful.tag.incnmaster(-1, nil, true)
    end,
    {
      description = "decrease the number of master clients",
      group = "layout"
    }
  ),

  -- Prompt
  awful.key({ modkey }, "r",
    function ()
      awful.screen.focused().mypromptbox:run()
    end,
    {description = "run prompt", group = "launcher"}
  ),

  -- Menubar
  awful.key({ modkey }, "p",
    function()
      menubar.show()
    end,
    {description = "show the menubar", group = "launcher"}
  ),

  -- Volume Keys
  awful.key({}, "XF86AudioLowerVolume",
    function ()
      awful.util.spawn(
        "pactl set-sink-volume @DEFAULT_SINK@ -5%",
        false
      )
    end
  ),

  awful.key({}, "XF86AudioRaiseVolume",
    function ()
      awful.util.spawn(
        "pactl set-sink-volume @DEFAULT_SINK@ +5%",
        false
      )
    end
  ),

  awful.key({}, "XF86AudioMute",
    function ()
      awful.util.spawn(
        "pactl set-sink-mute @DEFAULT_SINK@ toggle",
        false
      )
    end
  ),

  -- Brightness keys
  awful.key({}, "XF86MonBrightnessUp",
    function ()
      awful.util.spawn(
        "/home/mark/.dotfiles/scripts/inc_brightness.sh",
        false
      )
    end
  ),

  awful.key({}, "XF86MonBrightnessDown",
    function ()
      awful.util.spawn(
        "/home/mark/.dotfiles/scripts/dec_brightness.sh",
        false
      )
    end
  ),

  --{{{ gaps control
  -- decrease gap size
  awful.key({ modkey }, "-",
    function ()
      local tags = root.tags()
      for i = 1, #tags do
        awful.tag.incgap(-5, tags[i])
      end
    end,
    {description = "Decrease gap size", group = "appearance"}
  ),

  -- increase gap size
  awful.key({ modkey }, "=",
    function ()
      local tags = root.tags()
      for i = 1, #tags do
        awful.tag.incgap(5, tags[i])
      end
    end,
    {description = "Increase gap size", group = "appearance"}
  ),

  -- set gap size to zero
  awful.key({ modkey, "Shift" }, "-",
    function ()
      local tags = root.tags()
      for i = 1, #tags do
        awful.tag.incgap(-tags[i].gap, tags[i])
      end
    end,
    {description = "Remove gaps", group = "appearance"}
  ),

  -- change layout
  awful.key({ modkey }, "f",
    function ()
      local tags = awful.screen.focused().selected_tags
      for i = 1, #tags do
        tags[i].layout = awful.layout.suit.floating
      end
    end,
    {description = "Switch to floating layout", group = "layout"}
  ),

  awful.key({ modkey }, "t",
    function ()
      local tags = awful.screen.focused().selected_tags
      for i = 1, #tags do
        tags[i].layout = awful.layout.suit.tile
      end
    end,
    {description = "Switch to tiling layout", group = "layout"}
  ),

  awful.key({ modkey }, "w",
    function ()
      os.execute("maim -us ~/Pictures/$(date +%s).png")
    end,
    {description = "Take a screenshot", group = "utility"}
  )
)

clientkeys = gears.table.join(
  awful.key({ modkey }, "g",
    function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}
  ),

  awful.key({ modkey }, "c",
    function (c)
      c:kill()
    end,
    {description = "close", group = "client"}
  ),

  awful.key({ modkey }, "space", awful.client.floating.toggle,
            {description = "toggle floating", group = "client"}
  ),

  awful.key({ modkey }, "'",
    function (c)
      c:swap(awful.client.getmaster())
    end,
    {description = "move to master", group = "client"}
  )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      {description = "view tag #"..i, group = "tag"}
    ),

    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      {description = "toggle tag #" .. i, group = "tag"}
    ),

    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      {description = "move focused client to tag #"..i, group = "tag"}
    )
  )
end

clientbuttons = gears.table.join(
  awful.button({}, 1,
    function (c)
      c:emit_signal(
        "request::activate",
        "mouse_click",
        {raise = true}
      )
    end
  ),

  awful.button({ modkey }, 1,
    function (c)
      c:emit_signal(
        "request::activate",
        "mouse_click",
        {raise = true}
      )
      awful.mouse.client.move(c)
    end
  ),

  awful.button({ modkey }, 3,
    function (c)
      c:emit_signal(
        "request::activate",
        "mouse_click",
        {raise = true}
      )
      awful.mouse.client.resize(c)
    end
  )
)

-- Set keys
root.keys(globalkeys)

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
      size_hints_honor = true
    }
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA",  -- Firefox addon DownThemAll.
        "copyq",  -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        -- TOR browser needs a fixed window size to avoid 
        -- fingerprinting by screen size.
        "Tor Browser",
        "Wpa_gui",
        "veromix",
        "xtightvncviewer"
      },

      -- Note that the name property shown in xprop might be set
      -- slightly after creation of the client and the name shown
      -- there might not match defined rules here.
      name = {
        "Event Tester",  -- xev.
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "ConfigManager",  -- Thunderbird's about:config.
        "pop-up",       -- e.g. Google Chrome's (detached) Dev Tools.
      }
    },
    properties = { floating = true }
  },
  { rule_any = {
      class = {
        "Polybar",
        "polybar"
      }
    },
    properties = {
      border_width = 0
    }
  }

  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- { rule = { class = "Firefox" },
  --   properties = { screen = 1, tag = "2" } },
}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage",
  function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count
        -- changes.
        awful.placement.no_offscreen(c)
    end
  end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter",
  function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
  end
)

client.connect_signal("focus",
  function(c)
    c.border_color = beautiful.border_focus
  end
)

client.connect_signal("unfocus",
  function(c)
    c.border_color = beautiful.border_normal
  end
)

