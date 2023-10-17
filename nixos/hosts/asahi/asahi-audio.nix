{ pkgs, ...}:
let
   src = pkgs.fetchFromGitHub {
    owner = "chadmed";
    repo = "asahi-audio";
    rev = "1840ff1235cc72391d581a8c62d73a93c9245bcb";
    sha256 = "sha256-9zzcURjF23NdAogwbvOeL6Yl8E2mnWnU/r6ihqaCaMo=";
  };
  
in pkgs.stdenvNoCC.mkDerivation { 
  name = "asahi-audio";
  inherit src;

  installPhase = ''
    mkdir -p $out/etc/wireplumber/{main,policy}.lua.d
    mkdir -p $out/etc/pipewire/pipewire.conf.d
    mkdir -p $out/share/asahi-audio

    cp $src/conf/99-asahi-policy.lua $out/etc/wireplumber/policy.lua.d/
    cp $src/conf/99-asahi-monitor.lua $out/etc/wireplumber/main.lua.d/
    cp $src/conf/99-asahi.conf $out/etc/pipewire/pipewire.conf.d/

    cp -r $src/firs/* $out/share/asahi-audio

    substituteInPlace $out/etc/wireplumber/main.lua.d/*.lua \
      --replace /usr/share/asahi-audio $out/share/asahi-audio

    substituteInPlace $out/etc/wireplumber/policy.lua.d/*.lua \
      --replace /usr/share/asahi-audio $out/share/asahi-audio

    substituteInPlace $out/share/asahi-audio/*/*.json \
      --replace /usr/share/asahi-audio $out/share/asahi-audio
  '';
}
