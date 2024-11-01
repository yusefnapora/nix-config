{ pkgs, lib, inputs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  imports = [
    ./common.nix
    ../features/yabai.nix
    ../features/brew.nix
  ];

  users.users = {
    ynapora = {
      name = "ynapora";
      home = "/Users/ynapora";
    };
  };
  
  home-manager.users.ynapora = import ../../home-manager/yusef/hosts/work-macbook-darwin.nix;

  system.stateVersion = 4;
}
