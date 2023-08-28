# Host config for work vm on 16" intel macbook (vmware)

{ config, pkgs, lib, inputs, outputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../../common.nix

      # enable various features
      ../../features/sound.nix
      ../../features/tailscale.nix
      ../../features/sway.nix

      # font config
      ../../features/hidpi.nix
    ];

  home-manager.users.yusef = import ../../../home-manager/yusef/hosts/detritus.nix;

  virtualisation.vmware.guest.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "detritus"; # Define your hostname.

  system.stateVersion = "23.05";
}

