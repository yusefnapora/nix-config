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
    hostName = "cloud.napora.org";
    https = true;
    config = {
      adminuser = "root";
      adminpassFile = config.age.secrets.nextcloud-admin-pass.path;
      overwriteProtocol = "https";
    };
  };


  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };
}
