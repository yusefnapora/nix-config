{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop/common
    (import ../features/desktop/sway { 
      inherit inputs outputs lib pkgs config;
    })
  ];

  monitors = [
    {
      name = "DP-1";
      width = 3024;
      height = 1890;
      scale = 2.0;
    }
  ];
}