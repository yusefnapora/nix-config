{ lib
, pkgs
,... }:
pkgs.stdenvNoCC.mkDerivation {
  name = "material-icons-font";
  dontConfigure = true;
  src = ./.; 

  installPhase = ''
  mkdir -p $out/share/fonts/{opentype,truetype}
  cp $src/*.otf $out/share/fonts/opentype/
  cp $src/*.ttf $out/share/fonts/truetype/
  '';
}