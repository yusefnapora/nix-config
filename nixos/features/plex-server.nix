{ pkgs, lib, ... }:
{
  # enable Plex server
  services.plex = let
    plexpass = pkgs.plex.override {
      plexRaw = pkgs.plexRaw.overrideAttrs (old: rec {
        version = "1.31.0.6654-02189b09f";
        src = pkgs.fetchurl {
          url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
          sha256 = "sha256-TTEcyIBFiuJTNHeJ9wu+4o2ol72oCvM9FdDPC83J3Mc=";
        };
      });
    };

    audnexus-plugin = pkgs.fetchFromGitHub {
      owner = "djdembeck";
      repo = "Audnexus.bundle";
      rev = "v1.1.0";
      sha256 = "sha256-eylY/fOfMRiDBFaFN1DUyISm/8FO9tRTGE6J/Owkqds=";
    };
  in {
    enable = true;
    openFirewall = true;
    #package = plexpass;
    #extraPlugins = [
    #  (builtins.path {
    #    name = "Audnexus.bundle";
    #    path = audnexus-plugin;
    #  })
    #];
  };
}
