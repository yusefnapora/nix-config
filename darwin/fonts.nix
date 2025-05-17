{ pkgs, outputs, ... }:
let 
  inherit (pkgs.stdenv) system;

  nerdFonts = with pkgs.nerd-fonts; [
    fira-code
    droid-sans-mono
    jetbrains-mono
    fantasque-sans-mono
    iosevka
  ];
in {
  fonts = {
    packages = nerdFonts ++ builtins.attrValues {
      inherit (pkgs)
        fira-code
        open-fonts
        powerline-fonts
        liberation_ttf
        iosevka
        monaspace
        ;
    };
  };
}
