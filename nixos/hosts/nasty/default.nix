# Host config for home NAS box / plex server

{ lib, config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # base config
      ../../common.nix

      # samba share config
      ./samba-conf.nix

      # optional features
      ../../features/tailscale.nix
      ../../features/plex-server.nix

      # font config
      (import ../../features/fonts.nix { 
        inherit pkgs lib;
      })

      # key mappings
      (import ../../features/key-remap.nix {
        inherit pkgs lib config;
        caps-to-ctrl-esc = true;
        right-alt-to-ctrl-b = true;
      })

    ];

  # enable ZFS
  # see: https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/index.html  
  boot.supportedFilesystems = [ "zfs" ];
  # set hostId to first 8 chars of /etc/machine-id
  networking.hostId = "f94f2c6c";
  # import pools on boot
  boot.zfs.extraPools = [ "ocean" ];


  systemd.targets.hibernate.enable = false;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) audible-cli ffmpeg;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nasty"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.enp3s0.useDHCP = true;

  system.stateVersion = "22.11";
}

