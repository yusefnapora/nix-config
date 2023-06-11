{ pkgs, lib, inputs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  imports = [
    ./common.nix
  ];

  # home-manager.users.yusef = import ../../home-manager/yusef/hosts/macbook-darwin.nix;

  system.stateVersion = 4;
}
