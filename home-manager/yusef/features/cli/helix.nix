{ lib, pkgs, ... }:
let

  themes-repo = pkgs.fetchFromGitHub {
    owner = "CptPotato";
    repo = "helix-themes";
    rev = "0ebf77d9e1dc3ee71fbb2a2956810cfc131d0008";
    sha256 = "sha256-Cr4NEEFq3XOmOvbsYpRUGkOY1Mq7wIFJzxVhf8e9T0c=";
  };
  

  scheme-edge = (builtins.readFile "${themes-repo}/schemes/edge");
  palette-neon = (builtins.readFile "${themes-repo}/palettes/edge/neon");
  theme-edge-neon = lib.strings.concatStringsSep "\n" [scheme-edge palette-neon];
in
{
  home.packages = [ pkgs.helix ];

  home.file."helix-config" = {
    target = ".config/helix/config.toml";
    text = ''
      theme = "edge-neon"
    '';
  };

  home.file."helix-theme-edge-neon" = {
    target = ".config/helix/themes/edge-neon.toml";
    text = theme-edge-neon;
  };
}