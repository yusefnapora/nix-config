{ config, ... }:
{
  wayland.windowManager.sway.config.bars = [{ command = "waybar"; }];

  programs.waybar.settings.mainBar = {
     modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
     modules-center = [ "sway/window" ];
  };
}
