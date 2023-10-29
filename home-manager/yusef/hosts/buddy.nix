{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop/common

    ../features/desktop/i3
  ];

  monitors = [
    #{
    #  name = "Virtual-1";
    #  width = 3072;
    #  height = 1920;
    #  scale = 2.0;
    #}
  ];
}
