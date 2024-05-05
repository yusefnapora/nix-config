{ pkgs, lib, ... }:
{
  programs.steam = {
    enable = true;

    extraCompatPackages = lib.optionals (pkgs.system == "x86_64-linux") [
      pkgs.proton-ge-bin
    ];
  };
}
