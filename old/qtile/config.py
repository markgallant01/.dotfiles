# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal, send_notification
from libqtile.log_utils import logger

mod = "mod4"
terminal = guess_terminal()

keys = [
    # A list of available commands that can be bound to keys can be
    # found at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),

    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),

    # Move windows between left/right columns or move up/down in
    # current stack. Moving out of range in Columns layout will create
    # new column.
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),

    Key([mod, "shift"], "k", lazy.layout.shuffle_up(),
        desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and
    # direction will be to screen edge - window would shrink.
    Key([mod], "h", lazy.layout.shrink_main(),
        desc="Move focus to left"),

    Key([mod], "l", lazy.layout.grow_main(),
        desc="Move focus to right"),

    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    Key([mod], "c", lazy.window.kill(), desc="Kill focused window"),

    Key([mod], "g", lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window"),

    Key([mod], "f", lazy.to_layout_index(1),
        desc="Swap to floating display"),

    Key([mod], "t", lazy.to_layout_index(0),
        desc="Swap to master stack tiling display"),

    Key([mod, "control"], "r", lazy.reload_config(),
        desc="Reload the config"),

    Key([mod, "control"], "q", lazy.shutdown(),
        desc="Shutdown Qtile"),

    Key([mod], "p", lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"),

    Key([mod], "s", lazy.display_kb(),
        desc="Display keybind menu"),

    # keyboard backlight controls
    Key([], "XF86MonBrightnessUp",
        lazy.spawn("/home/mark/.dotfiles/scripts/inc_brightness.sh"),
        desc="Increase brightness"),

    Key([], "XF86MonBrightnessDown",
        lazy.spawn("/home/mark/.dotfiles/scripts/dec_brightness.sh"),
        desc="Decrease brightness"),

    # keyboard volume controls
    Key([], "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
        desc="Increase volume"),

    Key([], "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
        desc="Descrese volume"),

    Key([], "XF86AudioMute",
        lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
        desc="Toggle audio mute"),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend([
        # mod + group number = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc=f"Switch to group {i.name}"),

        # mod + shift + group number = move
        # focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            desc="move focused window to group {}".format(i.name)),
    ])

layouts = [
    layout.MonadTall(
        margin=15,
        new_client_position="top",
    ),
    layout.Floating(),
]

widget_defaults = dict(
    font="sans",
    fontsize=16,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    highlight_method='block',
                    rounded=True,
                    margin_x=3,
                ),
                widget.CurrentLayoutIcon(),
                widget.Prompt(),
                widget.Spacer(length=bar.STRETCH),

                # NB Systray is incompatible with Wayland, consider
                # using StatusNotifier instead widget.StatusNotifier(),
                widget.Systray(icon_size=25),
                widget.CPU(format="[CPU:{load_percent}%]"),
                widget.Backlight(
                    backlight_name="intel_backlight",
                    format="[BRI:{percent:2.0%}]"
                ),
                widget.Volume(fmt="[VOL:{}]"),
                widget.Battery(
                    format="[BAT:{percent:2.0%}]",
                    show_short_text=False,
                ),
                widget.Clock(format="%I:%M %p"),
            ],
            32,
            margin=[15,15,0,15], # border margin [N,E,S,W]
            border_width=[3, 10, 3, 10],  # Draw borders
            opacity=0.75,
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  
            # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 
        # floating resize/moving is laggy
        # By default we handle these events delayed to already improve
        # performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can
        # set it to 60 to indicate that you limit it to 60 events per 
        # second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),

    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),

    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = True
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of
        # an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="blueman-manager"),
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when 
# losing focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input
# devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares
# about this string besides java UI toolkits; you can see several
# discussions on the mailing lists, GitHub issues, and other WM
# documentation that suggest setting this string if your java app
# doesn't work correctly. We may as well just lie and say that we're
# a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM
# written in java that happens to be on java's whitelist.
wmname = "LG3D"

# custom hooks
# disable floating on all windows when layout changes from floating
# to something else
@hook.subscribe.layout_change
def _(layout, group):
    logger.warning(layout.info())
    if(layout.name != "floating"):
        for window in group.windows:
            window.floating = False

