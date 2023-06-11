# Host config for 14" M1-Pro macbook pro 

{ config, pkgs, lib, inputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # apple-silicon hardware support
      inputs.apple-silicon.nixosModules.apple-silicon-support
      
      ../../common.nix

      # enable various features
      ../../features/sound.nix
      ../../features/bluetooth.nix
      ../../features/tailscale.nix
      ../../features/sway.nix

      # font config
      ../../features/hidpi.nix

      # key mappings
      (import ../../features/key-remap.nix {
        inherit pkgs lib config;
        caps-to-ctrl-esc = true;
        right-alt-to-ctrl-b = true;
      })

    ];

  home-manager.users.yusef = import ../../../home-manager/yusef/hosts/asahi.nix;

  # asahi linux overlay
  # nixpkgs.overlays = [ inputs.apple-silicon.overlays.apple-silicon-overlay ];

  # enable GPU support
  hardware.asahi.useExperimentalGPUDriver = true;
  hardware.asahi.experimentalGPUInstallMode = "replace";

  # backlight control
  programs.light.enable = true;  
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
    ];
  };

  # use TLP for power management
  services.tlp = {
    enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "asahi"; # Define your hostname.
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  system.stateVersion = "23.05";
}

