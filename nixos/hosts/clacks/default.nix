{ lib, config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../minimal.nix
    ];

  home-manager.user.yusef = import ../../../home-manager/yusef/hosts/clacks.nix;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "clacks"; # Define your hostname.
  system.stateVersion = "23.05";
}

