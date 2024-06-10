{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop/common

    ../features/desktop/common/davinci-resolve.nix
    
    #../features/desktop/sway 
    #../features/desktop/sway/natural-scrolling.nix
    #../features/desktop/sway/nvidia.nix
    #../features/desktop/sway/no-hardware-cursors.nix
    #../features/desktop/i3
    #../features/desktop/hyprland
    #../features/desktop/hyprland/nvidia.nix
  ];

  # TODO: switch back to wezterm if we get it working with nvida + wayland
  # home.sessionVariables.TERMINAL = "alacritty";

  monitors = [
    {
      name = "DP-1";
      width = 3840;
      height = 2160;
      scale = 1.0;
    }
  ];
}
