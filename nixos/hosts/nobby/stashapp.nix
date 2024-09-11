{ pkgs, config, outputs, ... }:
let
  hostName = "nobby";
  tailnetName = "chimera-tone";
  data-path = "/mnt/disks/storage-1/media/smut";
  state-path = "/mnt/disks/storage-1/docker/stash";
in {

  imports = [ outputs.nixosModules.ts-serve ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      stashapp = {
        image = "stashapp/stash:latest";
        # ports = ["9999:9999"];
        extraOptions = [
          "--network=container:TSstash"
        ];
        dependsOn = [ "TSstash" ];
        environment = {
          STASH_STASH = "/data/";
          STASH_GENERATED = "/generated/";
          STASH_METADATA = "/metadata/";
          STASH_CACHE = "/cache";
          STASH_BLOBS = "/blobs";
        };
        volumes = [
          "/etc/zoneinfo/America/New_York:/etc/localtime:ro"
          "${data-path}:/data"
          "${state-path}/config:/root/.stash"
          "${state-path}/metadata:/metadata"
          "${state-path}/cache:/cache"
          "${state-path}/blobs:/blobs"
          "${state-path}/generated:/generated"
        ];
      };
    };
  };

  yomaq.pods.tailscaled."TSstash" = {
    TSserve = {
      "/" = "http://127.0.0.1:9999";
    };
    TShostname = "stash";
    tags = [ "tag:container" ];
  };

}
