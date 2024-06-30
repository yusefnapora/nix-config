{ pkgs, ... }:
{
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
  };

}
