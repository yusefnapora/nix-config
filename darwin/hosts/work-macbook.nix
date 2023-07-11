{ pkgs, lib, inputs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  imports = [
    ./common.nix
    ../features/yabai.nix
    ../features/yabai-scripting-additions.nix
  ];

  home-manager.users.yusef = import ../../home-manager/yusef/hosts/work-macbook-darwin.nix;

  system.stateVersion = 4;
}
