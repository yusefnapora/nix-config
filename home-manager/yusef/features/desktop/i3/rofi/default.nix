{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf;

  dpi-scale = 1.0; # TODO: read from monitor config
  scaled = size: (lib.strings.floatToString (size * dpi-scale));
in
{
  programs.rofi = {
    enable = true;

    plugins = builtins.attrValues {
      inherit (pkgs) rofi-emoji rofi-calc;
    };

    terminal = "$TERMINAL";

    theme = (import ./theme.nix { inherit scaled; inherit config; });

    extraConfig = {
      modi = "drun,run,emoji,calc,ssh,combi,window";
    };
  };
}
