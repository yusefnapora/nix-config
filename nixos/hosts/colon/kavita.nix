{ pkgs, config, ... }:
let
  port = 5000;
in {

  age.secrets.kavita-token = {
    file = ../../../secrets/kavita-token.age;
    owner = "kavita";
    group = "kavita";
    mode = "770";
  };

  services.kavita = {
    enable = true;
    dataDir = "/data/kavita";
    tokenKeyFile = config.age.secrets.kavita-token.path;

    settings = {
      Port = port;
      IpAddresses = "127.0.0.1";
    };
  };

  services.nginx.virtualHosts = {
    "library.napora.org" = {
      forceSSL = true;
      enableACME = true;
      http2 = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${(builtins.toString port)}";
        proxyWebsockets = true;
      };
    };
  };
}
