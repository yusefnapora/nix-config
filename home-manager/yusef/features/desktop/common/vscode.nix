{ pkgs, lib, ... }:
{
  programs.vscode = {
    enable = true;
    package = lib.mkDefault pkgs.vscode-fhs;
  };
}
