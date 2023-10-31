# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: rec {
  custom-fonts = pkgs.callPackage ./fonts { };
  trim-screencast = pkgs.callPackage ./trim-screencast.nix { };
  wrapWine = pkgs.callPackage ./wrapWine.nix { };
  kindle_1_17 = pkgs.callPackage ./wineApps/kindle.nix {
    inherit wrapWine;
  };
  native-access = pkgs.callPackage ./wineApps/native-access.nix {
    inherit wrapWine;
  };
  speakersafetyd = pkgs.callPackage ./speakersafetyd.nix {};
  airwave = pkgs.libsForQt5.callPackage ./airwave.nix {};
}
