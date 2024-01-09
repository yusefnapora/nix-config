{ pkgs, config, ... }:
{
  age.secrets.photoprism-admin = {
    file = ../../../secrets/photoprism-admin.age;
    owner = "photoprism";
    group = "photoprism";
    mode = "770";
  };

  services.photoprism = {
    enable = true;
    port = 2342;
    passwordFile = config.age.secrets.photoprism-admin.path;

    originalsPath = "/var/lib/private/photoprism/originals";
    address = "127.0.0.1";
    settings = {
      PHOTOPRISM_ADMIN_USER = "admin";
      PHOTOPRISM_DEFAULT_LOCALE = "en";
      PHOTOPRISM_DATABASE_DRIVER = "mysql";
      PHOTOPRISM_DATABASE_NAME = "photoprism";
      PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
      PHOTOPRISM_DATABASE_USER = "photoprism";
      PHOTOPRISM_SITE_URL = "https://pics.napora.org";
      PHOTOPRISM_SITE_TITLE = "Our Pics";
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "photoprism" ];
    ensureUsers = [ {
      name = "photoprism";
      ensurePermissions = {
        "photoprism.*" = "ALL PRIVILEGES";
      };
    } ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "yusef@napora.org";
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "pics.napora.org" = {
        forceSSL = true;
        enableACME = true;
        http2 = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:2342";
          proxyWebsockets = true;
        };
      };
    };
  };
}
