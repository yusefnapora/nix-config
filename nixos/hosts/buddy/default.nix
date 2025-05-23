# Host config for intel nuc used for music production & recording 

{ config, pkgs, lib, inputs, outputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # import module for musnix (music production kernel tuning, etc)
      # inputs.musnix.nixosModules.musnix

      ../../common.nix

      # enable various features
      ../../features/sound.nix
      ../../features/tailscale.nix
      ../../features/sway.nix
      ../../features/plex-server.nix
      #../../features/music-production.nix


      # key remapping
      outputs.nixosModules.dual-function-keys
      ../../features/key-mapping/caps-to-ctrl-esc.nix

      # font config
      ../../features/hidpi.nix
    ];

  home-manager.users.yusef = import ../../../home-manager/yusef/hosts/buddy.nix;

  # thunderbolt support
  services.hardware.bolt.enable = true;

  # doesn't seem to want to wake from hibernate...
  systemd.targets.hibernate.enable = false;

  services.logind.extraConfig = ''
    # set power button to suspend instead of poweroff
    HandlePowerKey=suspend
    # suspend when idle timer kicks in
    IdleAction=suspend
    IdleActionSec=45m
  '';

  # enable hw-accelerated video playback for intel GPU
  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
  };

  hardware.graphics = lib.mkForce {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  
  environment.sessionVariables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_ENABLE_HIGHDPI_SCALING = "1";
    GDK_SCALE = "2";
  };


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "buddy"; # Define your hostname.

  system.stateVersion = "23.05";
}

