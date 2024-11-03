{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop/common/wezterm.nix
    ../features/cli/syncthing.nix
  ];

  home.sessionPath = [ "/opt/homebrew/bin/" ];
}
