{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "monaspace";
  version = "1.000";
  src = pkgs.fetchFromGitHub {
    owner = "githubnext";
    repo = "monaspace";
    rev = "v${version}";
    sha256 = "sha256-Zo56r0QoLwxwGQtcWP5cDlasx000G9BFeGINvvwEpQs=";
  };
  
  installPhase = ''
    mkdir -p $out/share/fonts/{opentype,truetype}
    cp $src/fonts/otf/*.otf $out/share/fonts/opentype
    cp $src/fonts/variable/*.ttf $out/share/fonts/truetype
  '';
}
