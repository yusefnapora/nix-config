{ pkgs
, lib
, ...}:
let
  nerdFonts = [
    "FiraCode"
    "DroidSansMono"
    "JetBrainsMono"
    "FantasqueSansMono"
    "Iosevka"
  ];
in {
  # set the console font
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = lib.mkDefault "${pkgs.powerline-fonts}/share/consolefonts/ter-powerline-v16n.psf.gz";
    packages = [ pkgs.powerline-fonts ];
    keyMap = "us";
  };

  # accept the license for the Joypixels font
  nixpkgs.config.joypixels.acceptLicense = true;

  fonts.fontconfig = {
    enable = lib.mkForce true;

    defaultFonts = {
      serif = [ "Liberation Serif" "Joypixels" ];
      sansSerif = [ "SF Pro Display" "Joypixels" ];
      monospace = [ "FiraCode Nerd Font Mono" ];
      emoji = [ "Joypixels" ];
    };

    # fix pixelation
    antialias = true;

    # fix antialiasing blur
    hinting = {
      enable = true;
      style = "full";
      autohint = true;
    };

    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };
  };

  fonts.packages = [
    (pkgs.nerdfonts.override { fonts = nerdFonts; })
  ] ++ builtins.attrValues {
    inherit (pkgs)
      fira-code
      noto-fonts
      open-fonts
      powerline-fonts
      # helvetica-neue-lt-std
      liberation_ttf
      iosevka
      joypixels
      ;

      # custom fonts from this repo (see pkgs/fonts)
      inherit (pkgs.local-pkgs.custom-fonts) material-icons feather-icons sf-pro monaspace;
    };
}
