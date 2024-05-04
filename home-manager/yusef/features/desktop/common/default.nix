{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (builtins) attrValues;
  inherit (lib.lists) optionals;

  inherit (pkgs.stdenv) isLinux isx86_64;

  mkAsahiWrapper = (import ./asahi-wrapper.nix { inherit lib pkgs; });
  kitty = mkAsahiWrapper { name = "kitty"; package = pkgs.kitty; };

  common-packages = [ kitty pkgs.xfce.thunar ] 
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
    ./firefox.nix
    ./obs.nix
    ./wezterm.nix
    ./qt.nix
    ./vscode.nix
  ];

  programs.emacs.package = pkgs.emacs29-pgtk;

  home.packages =
    common-packages
    ++ optionals (isLinux && isx86_64) x86-linux-packages;

  wallpaper = lib.mkDefault ../backgrounds/jwst-carina.jpg;

}
