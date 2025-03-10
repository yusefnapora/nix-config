{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop/common

    ../features/desktop/sway
    ../features/desktop/sway/natural-scrolling.nix
  ];


  monitors = [
    {
      name = "Virtual-1";
      width = 3840;
      height = 2160;
      scale = 2.0;
    }
  ];
}
