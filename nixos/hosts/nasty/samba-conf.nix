{ pkgs, ... }:
{

  # Samba config
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = nasty
      netbios name = nasty
      security = user
      hosts allow = 192.168.86. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = let 
      common_attrs = {
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "yusef";
        "force group" = "users";      
      };
    in {
      media = {
        path = "/ocean/media";
      } // common_attrs;
      documents = {
        path = "/ocean/documents";
      } // common_attrs;
    };
  };
}
