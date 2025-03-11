{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop/common

    ../features/desktop/sway
  ];

  monitors = [
    {
      name = "Screen 0";
      width = 1920;
      height = 1080;
      scale = 1.0;
    }
  ];
}
