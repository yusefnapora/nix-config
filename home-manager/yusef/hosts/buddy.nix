{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop/common

    ../features/desktop/i3
  ];

  monitors = [
    {
      name = "Screen 0";
      width = 5120;
      height = 2880;
      scale = 2.0;
    }
  ];

  home.packages = [ 
    pkgs.local-pkgs.native-access
  ];
}
