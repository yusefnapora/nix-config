{ pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../minimal.nix
    ../../features/tailscale.nix

    ./wireguard.nix
    ./photoprism.nix
  ];

  virtualisation.docker.enable = true;

  home-manager.users.yusef = import ../../../home-manager/yusef/hosts/colon.nix;

  networking.hostName = "colon";
  networking.useDHCP = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  networking.nameservers = ["1.1.1.1" "8.8.8.8"];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.11";
}
