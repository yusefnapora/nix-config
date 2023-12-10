{ lib, config, pkgs, outputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # base config
      ../../common.nix

      # optional features
      ../../features/tailscale.nix
      ../../features/sound.nix
      #../../features/sway.nix
      #../../features/i3.nix
      ../../features/kindle

      # key remapping
      outputs.nixosModules.dual-function-keys
      ../../features/key-mapping/caps-to-ctrl-esc.nix
    ];

  programs.hyprland.enable = true;

  home-manager.users.yusef = import ../../../home-manager/yusef/hosts/nobby.nix;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) pciutils usbutils;
  };

  # nvidia GPU setup
  hardware.nvidia = {
    # use open-source driver
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    modesetting.enable = true;
    powerManagement.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  # Use grub instead of systemd-boot so we can use the OS prober to find Windows
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nobby"; # Define your hostname.

  # enable DHCP for all interfaces, since my usb ethernet adapter sometimes
  # gets its "predictable" name changed depending on what else is plugged in
  # at boot 
  networking.useDHCP = true;

  system.stateVersion = "22.11";
}

