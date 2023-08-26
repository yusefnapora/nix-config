{ lib, config, pkgs, ... }:
{
  imports = [
    ./i3.nix
    ./picom.nix
    ./polybar.nix
    # ./rofi
  ];
}
