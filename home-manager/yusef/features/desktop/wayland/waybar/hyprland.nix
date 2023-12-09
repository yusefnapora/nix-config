{ config, ... }:
{

  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = waybar &
  '';

  programs.waybar.settings.mainBar = {
     modules-left = [ "hyprland/workspaces" "hyprland/submap" "wlr/taskbar" ];
     modules-center = [ "hyprland/window" ];
  };
}
