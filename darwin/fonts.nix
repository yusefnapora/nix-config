{ pkgs, ... }:
let 
  nerd-fonts = [
    "FiraCode"
    "DroidSansMono"
    "JetBrainsMono"
    "FantasqueSansMono"
    "Iosevka"
  ];
in {
  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override { fonts = nerd-fonts; })
    ] ++ builtins.attrValues {
      inherit (pkgs)
        fira-code
        open-fonts
        powerline-fonts
        liberation_ttf
        iosevka
        ;
    };
  };
}