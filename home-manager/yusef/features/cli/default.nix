{ config, pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./nushell
    ./git.nix
    ./helix.nix
    ./npm.nix
    ./nvim
    ./ssh.nix
    ./tmux.nix
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      nixFlakes
      jq
      tealdeer
      unzip
      htop
      killall
      tree
      lnav
      duf
      ripgrep
      fd
      atool
      bat
      gron
      xh
      just
      ;
    };

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  
    nix-index = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  nixpkgs.config = import ./nixpkgs-config.nix;
  home.file."nixpkgs-config" = {
    target = ".config/nixpkgs/config.nix";
    source = ./nixpkgs-config.nix;
  };
  
}
