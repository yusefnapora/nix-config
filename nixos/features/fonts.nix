{ pkgs
, lib
, hidpiConsoleFont ? false
, nerdFonts ? [
    "FiraCode"
    "DroidSansMono"
    "JetBrainsMono"
    "FantasqueSansMono"
    "Iosevka"
  ]
}:
let
  console-font = if hidpiConsoleFont then "ter-powerline-v32n.psf.gz" else "ter-powerline-v16n.psf.gz";
in
{
  # set the console font
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.powerline-fonts}/share/consolefonts/${console-font}";
    packages = [ pkgs.powerline-fonts ];
    keyMap = "us";
  };

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
      style = "hintfull";
      autohint = true;
    };

    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };
  };

  fonts.fonts = [
    (pkgs.nerdfonts.override { fonts = nerdFonts; })
  ] ++ builtins.attrValues {
    inherit (pkgs)
      fira-code
      noto-fonts
      open-fonts
      powerline-fonts
      helvetica-neue-lt-std
      liberation_ttf
      iosevka
      joypixels
      ;

      # custom fonts from this repo (see pkgs/fonts)
      inherit (pkgs.custom-fonts) material-icons feather-icons sf-pro;
    };
}