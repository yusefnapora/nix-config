{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop/common/wezterm.nix
  ];

  home.username = lib.mkForce "ynapora";
  home.homeDirectory = lib.mkForce "/Users/ynapora";

  programs.ssh.matchBlocks = {
    "code.citrite.net" = {
      identityFile = "/Users/ynapora/.ssh/pdm-git-rsa__code-citrite-net";
      user = "git";
    };
  };
}