# enable picom compositor, so we can have transparency in polybar & other cool stuff
{ pkgs, lib, config, ... }:
{
  services.picom = {
    enable = true;
    fade = true;
    fadeDelta = 5;

    shadow = true;
    shadowOffsets = [ (-7) (-7) ];
    shadowOpacity = 0.7;
    shadowExclude = [ 
      "window_type *= 'normal' && ! name ~= ''"
      "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'" # don't draw multiple shadows for tabbed windows
      "class_g = 'firefox' && argb" # fix odd shadows for some firefox windows
        "class_i = 'rofi'" # disable shadows for rofi to fix odd corner rendering
    ];

    activeOpacity = 1.0;

    # set terminal windows to 80% opacity when unfocused.
    # using this instead of inactiveOpacity, since the latter is
    # too distracting when e.g. coding with a web-browser in split screen
    opacityRules = [
     "80: class_i = 'kitty' && focused != 1"
     "80: class_i = 'Alacritty' && focused != 1"
     "80: class_i = 'wezterm' && focused != 1"
     
     # don't render hidden windows (prevents semi-transparent tabbed windows)
     "0:_NET_WM_STATE@[0]:32a *= '_NET_WM_STATE_HIDDEN'"
     "0:_NET_WM_STATE@[1]:32a *= '_NET_WM_STATE_HIDDEN'"
     "0:_NET_WM_STATE@[2]:32a *= '_NET_WM_STATE_HIDDEN'"
     "0:_NET_WM_STATE@[3]:32a *= '_NET_WM_STATE_HIDDEN'"
     "0:_NET_WM_STATE@[4]:32a *= '_NET_WM_STATE_HIDDEN'"
    ];

    backend = "xrender";
    vSync = true;

  };
}
