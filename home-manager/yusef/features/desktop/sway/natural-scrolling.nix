{ config, ... }:
{
  wayland.windowManager.sway.config.input = {
    "type:pointer" = { 
      natural_scroll = "enabled";
    };

    "type:touchpad" = { 
      natural_scroll = "enabled";
    };

    "type:mouse" = {
      natural_scroll = "enabled";
    };
  };
}
