{ lib, config, pkgs, outputs, ... }:
let 
  # eth-interface = "enp0s20f0u7u2u1";
  eth-interface = "enp0s20f0u2";
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # base config
      ../../common.nix

      # optional features
      ../../features/tailscale.nix
      ../../features/sound.nix
      #../../features/sway.nix
      ../../features/i3.nix
      ../../features/kindle

      # key remapping
      outputs.nixosModules.dual-function-keys
      ../../features/key-mapping/caps-to-ctrl-esc.nix
    ];

  
  home-manager.users.yusef = import ../../../home-manager/yusef/hosts/nobby.nix;


  # custom options
  # yusef = {
  #  gui.enable = true;
  #  sound.enable = true;
  #  bluetooth.enable = true;
  #  nixpkgs-wayland.enable = true;
  #  sway = {
  #    enable = true; 
  #    natural-scrolling = true;
  #    nvidia = true;
  #    no-hardware-cursors-fix = true;
  #  };
  #  key-remap = { 
  #    enable = true; 
  #    caps-to-ctrl-esc= true; 
  #    swap-left-alt-and-super = true;
  #  };
  #  docker.enable = true;
  #  droidcam.enable = true;
  #  obs.enable = true;
  #  streamdeck.enable = true;
  #  kindle.enable = true;
  #};

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) pciutils usbutils;
  };

  # doesn't seem to want to wake from hibernate...
  # systemd.targets.hibernate.enable = false;

  #powerManagement.resumeCommands = 
  #  ''
  #  echo "waking TV on resume from sleep"
  #  ${pkgs.yusef.lgtv}/bin/lgtv -c /root/.config/lgtv/config wakeonlan
  #  '';

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

  # "nuclear" fix for random flickering
  # see: https://wiki.hyprland.org/hyprland-wiki/pages/Nvidia/
  #boot.extraModprobeConfig = ''
  #  options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3"
  ##'';

  # Use grub instead of systemd-boot so we can use the OS prober to find Windows
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nobby"; # Define your hostname.


  networking.useDHCP = false;
  networking.interfaces.${eth-interface}.useDHCP = true;

  system.stateVersion = "22.11";
}

