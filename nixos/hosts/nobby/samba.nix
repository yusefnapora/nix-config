{ pkgs, config, ... }:
{

  # Samba config
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = let 
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
      global = {
        workgroup = "WORKGROUP";
        "server string" = config.networking.hostName;
        "netbios name" = config.networking.hostName;
        security = "user";
        "hosts allow" = "192.168.86. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      rustbucket = {
        path = "/mnt/rustbucket";
      } // common_attrs;

      storage1 = {
        path = "/mnt/disks/storage-1";
      } // common_attrs;
    };
  };
}
