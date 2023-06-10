{ config, lib, pkgs, ...}:
{
  # configure npm to install global packages to ~/.npm-packages
  # based on this blog post: https://matthewrhone.dev/nixos-npm-globally

  home.activation.npm-packages = ''
    mkdir -p $HOME/.npm-packages/lib
  '';

  home.file.".npmrc".text = ''
    prefix = ''${HOME}/.npm-packages
  '';

  programs.fish.shellInit = ''
  set -x PATH $PATH $HOME/.npm-packages/bin
  set -x NODE_PATH $HOME/.npm-packages/lib/node_modules
  '';
}
