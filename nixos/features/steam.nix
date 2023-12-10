{ pkgs, lib, inputs, ... }:
{
  imports = [
    inputs.nix-gaming.nixosModules.steamCompat
  ];

  programs.steam = {
    enable = true;

    extraCompatPackages = lib.optionals (pkgs.system == "x86_64-linux") [
      inputs.nix-gaming.packages.${pkgs.system}.proton-ge
    ];
  };
}
