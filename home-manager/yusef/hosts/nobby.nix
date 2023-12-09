{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop/common
    #../features/desktop/sway 
    #../features/desktop/sway/natural-scrolling.nix
    #../features/desktop/sway/nvidia.nix
    #../features/desktop/sway/no-hardware-cursors.nix
    #../features/desktop/i3
    ../features/desktop/hyprland
    ../features/desktop/hyprland/nvidia.nix
  ];

  monitors = [
    {
      name = "DP-1";
      width = 3840;
      height = 2160;
      scale = 1.0;
    }
  ];
}
