{ self, pkgs, lib, config, ... }:
let
  domain = "plausible.napora.org";
in {
  age.secrets = {
    plausible-admin-password.file = "${self}/secrets/plausible-admin-password.age";
    plausible-secret-keybase.file = "${self}/secrets/plausible-secret-keybase.age";
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "yusef@napora.org";
  };

  services = {
    nginx.enable = true;

    nginx.virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://127.0.0.1:${toString config.services.plausible.server.port}";
    };

    plausible = {
      enable = true;

      adminUser = {
        activate = true;
        email = "yusef@napora.org";
        passwordFile = config.age.secrets.plausible-admin-password.path;
      };

      server = {
        baseUrl = "https://${domain}";
        secretKeybaseFile = config.age.secrets.plausible-secret-keybase.path;
      };
    };

  };

}
