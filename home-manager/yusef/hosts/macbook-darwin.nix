{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop/common/wezterm.nix
  ];

  home.sessionPath = [ "/opt/homebrew/bin/" ];
}
