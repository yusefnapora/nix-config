{ lib
, pkgs
,... }:
pkgs.stdenvNoCC.mkDerivation {
  name = "feather-icons-font";
  dontConfigure = true;
  src = ./.;

  installPhase = ''
  mkdir -p $out/share/fonts/truetype
  cp $src/feathericon.ttf $out/share/fonts/truetype/
  '';
}