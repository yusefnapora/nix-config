{ pkgs, config, ... }:
{

  age.secrets.nextcloud-admin-pass = {
    file = ../../../secrets/colon-nextcloud.age;
    mode = "770";
    owner = "nextcloud";
    group = "nextcloud";
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "yusef@napora.org";
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    datadir = "/data/nextcloud";
    hostName = "cloud.napora.org";
    maxUploadSize = "50G";
    https = true;
    config = {
      adminuser = "root";
      adminpassFile = config.age.secrets.nextcloud-admin-pass.path;
    };
    settings = {
      overwriteprotocol = "https";
    };
  };


  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };
}
