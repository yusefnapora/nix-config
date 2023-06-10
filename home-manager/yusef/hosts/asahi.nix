{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop/common
    (import ../features/desktop/sway { 
      inherit inputs outputs lib pkgs config;
    })
  ];
}