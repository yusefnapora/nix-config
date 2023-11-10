{ pkgs, outputs, ... }:
let 
  inherit (pkgs.stdenv) system;

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
      # TODO: figure out why nixpkgs overlays aren't working for darwin
      outputs.packages.${system}.custom-fonts.monaspace
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
