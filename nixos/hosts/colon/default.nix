{ pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../minimal.nix
    ../../features/podman.nix
    ../../features/tailscale.nix
  ];

  home-manager.users.yusef = import ../../../home-manager/yusef/hosts/colon.nix;

  networking.hostName = "colon";
  networking.useDHCP = true;
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.11";
}
