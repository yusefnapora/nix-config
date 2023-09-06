{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop/common
    (import ../features/desktop/sway { 
      inherit inputs outputs lib pkgs config;
      no-hardware-cursors-fix = true;
      natural-scrolling = true;
    })
  ];

  colorScheme = inputs.nix-colors.colorSchemes.snazzy;

  monitors = [
    {
      name = "Virtual-1";
      width = 3072;
      height = 1920;
      scale = 2.0;
    }
  ];
}
