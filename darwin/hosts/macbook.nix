{ pkgs, lib, inputs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  imports = [
    ./common.nix
    ../features/yabai.nix
    ../features/yabai-scripting-additions.nix
    ../features/brew.nix
  ];

  home-manager.users.yusef = import ../../home-manager/yusef/hosts/macbook-darwin.nix;

  ids.gids.nixbld = 350;
  system.stateVersion = 4;
}
