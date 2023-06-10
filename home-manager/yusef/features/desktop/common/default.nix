{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (builtins) attrValues;
  inherit (lib.lists) optionals;

  inherit (pkgs.stdenv) isLinux isx86_64;

  mkAsahiWrapper = (import ./asahi-wrapper.nix { inherit lib pkgs; });
  kitty = mkAsahiWrapper { name = "kitty"; package = pkgs.kitty; };

  common-packages = [ kitty ] 
    ++ attrValues {
      inherit (pkgs)
        dmenu
        chromium
        zeal
        tigervnc
        obsidian
        _1password-gui
        vlc
        mpv
        bookworm
        ;
      };

    x86-linux-packages = attrValues {
      inherit (pkgs)
        calibre
        zoom-us
        slack
        logseq
        simplescreenrecorder
        ;
    };
in {
  imports = [
    ./fonts.nix
    ./alacritty.nix
    ./firefox.nix # FIXME: figure out how to configure unfree packages for 1password addon
    ./obs.nix
    ./wezterm.nix
    # TODO: add vscode config
  ];

  home.packages =
    common-packages
    ++ optionals (isLinux && isx86_64) x86-linux-packages;

  # set default browser to firefox
  xdg = mkIf isLinux {
    mime.enable = true;
    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
    };
  };
}
