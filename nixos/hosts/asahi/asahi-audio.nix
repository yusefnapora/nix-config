{ pkgs, ...}:
let
   src = pkgs.fetchFromGitHub {
    owner = "chadmed";
    repo = "asahi-audio";
    rev = "1c6cefb8d8a6302b1480628d15411dfb9567a7a3";
    sha256 = "sha256-pOuGD27bgUUbuW/gYVQWS8DIXa4MgEzW3Pb+KKsFuNY=";
  };
  
in pkgs.stdenvNoCC.mkDerivation { 
  name = "asahi-audio";
  inherit src;

  installPhase = ''
    mkdir -p $out/etc/wireplumber/asahi.lua.d
    cp $src/conf/* $out/etc/wireplumber/asahi.lua.d/

    mkdir -p $out/share/asahi-audio
    cp -r $src/firs/* $out/share/asahi-audio/

    substituteInPlace $out/etc/wireplumber/asahi.lua.d/*.lua \
      --replace /usr/share/asahi-audio $out/share/asahi-audio

    substituteInPlace $out/share/asahi-audio/*/*.json \
      --replace /usr/share/asahi-audio $out/share/asahi-audio
  '';
}
