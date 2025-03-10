# Host config for 2018 dell xps 13 

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
       
     outputs.nixosModules.dual-function-keys
     ../../features/key-mapping/caps-to-ctrl-esc.nix
     ../../features/key-mapping/swap-left-alt-and-super.nix

      # font config
      ../../features/hidpi.nix
    ];

  home-manager.users.yusef = import ../../../home-manager/yusef/hosts/magrat.nix;

  virtualisation.docker.enable = true;
  services.hardware.bolt.enable = true;
  services.fwupd.enable = true;

  environment.systemPackages = [ pkgs.fprintd ];
  services.fprintd = {
    enable = true;
    #tod = {
    #  enable = true;
    #  driver = pkgs.libfprint-2-tod1-vfs0090;
    #};
  };
  security.pam.services.swaylock = {
    text = ''
      auth sufficient pam_unix.so try_first_pass likeauth nullok
      auth sufficient pam_fprintd.so
      auth include login
    '';
  };


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "magrat"; # Define your hostname.
  networking.networkmanager.enable = true;

  system.stateVersion = "24.05";
}

