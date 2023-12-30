{ pkgs, config, ... }:
{

  age.secrets.nextcloud-admin-pass.file = ../../../secrets/colon-nextcloud.age;

  services.nextcloud = {
    enable = true;
    domain = "cloud.napora.org";
    config = {
      adminpassFile = config.age.secrets.nextcloud-admin-pass.path;
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
