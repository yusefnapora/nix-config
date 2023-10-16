{ pkgs }:
let
  src = pkgs.fetchFromGitHub { 
    owner = "AsahiLinux";
    repo = "speakersafetyd";
    rev = "cfde41c18e2e6a5f673c6883e3ecdecbfce2b6b5";
    sha256 = "sha256-oEltRXQot+4QGplyt3E/7jmQ3irNFoZAKrDOworGk4Y=";
  };
  version = "0.1.3";
in pkgs.rustPlatform.buildRustPackage {
  pname = "speakersafetyd";
  inherit version src;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [ pkgs.pkg-config ];
  PKG_CONFIG_PATH = "${pkgs.alsa-lib.dev}/lib/pkgconfig";

  postInstall = ''
    mkdir -p $out/share/speakersafetyd
    cp -r $src/conf/* $out/share/speakersafetyd
  '';
}
