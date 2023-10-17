{ pkgs }:
let
  src = pkgs.fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "alsa-ucm-conf-asahi";
    rev = "427c12828b1ddca19c5c7c8b2918ef6a4b423253";
    sha256 = "sha256-ZLPpFwWL47Vwc8tRvLo2m/3ocSVNSBHBIRLS+TENr78=";
  };
  asahi-conf = pkgs.stdenvNoCC.mkDerivation {
    inherit src;
    name = "alsa-ucm-conf-asahi";

    installPhase = ''
      mkdir -p $out/share/alsa/ucm2/conf.d/macaudio
      cp -r $src/ucm2/conf.d/macaudio/* $out/share/alsa/ucm2/conf.d/macaudio/
    '';
  };
in pkgs.symlinkJoin {
  name = "alsa-ucm-conf-asahi-combined";
  paths = [ pkgs.alsa-ucm-conf asahi-conf ];
}
