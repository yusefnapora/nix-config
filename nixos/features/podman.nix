{ pkgs, lib, ... }:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.oci-containers.backend = "podman";
  environment.systemPackages = [ pkgs.podman-compose pkgs.distrobox ];
}
