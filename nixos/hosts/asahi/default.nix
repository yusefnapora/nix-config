# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
      (import ../../features/fonts.nix { 
        inherit pkgs lib;
        hidpiConsoleFont = true; 
      })

      # key mappings
      (import ../../features/key-remap.nix {
        inherit pkgs lib config;
        caps-to-ctrl-esc = true;
        right-alt-to-ctrl-b = true;
      })

    ];

  # custom options
  # yusef = {
  #   system = "aarch64-linux";
  #   hidpi = true;
  #   gui.enable = true;
  #   sound.enable = true;
  #   bluetooth.enable = true;
  #   droidcam.enable = true;
  #   obs.enable = true;
  #   sway = {
  #     enable = true;
  #     natural-scrolling = true;
  #     terminal = "alacritty";
  #     output = {
  #       eDP-1 = {
  #         scale = "2";
  #       };
  #     };

  #     # set the playback volume on the headphone jack to 100%
  #     # since it seems to reset to zero on boot.
  #     # The actual volume will be controlled by pulseaudio / pipewire
  #     startup-commands = [
  #       { command = "${pkgs.alsa-utils}/bin/amixer -c 1 set 'Jack DAC' 100%"; }
  #     ];
  #   };
  #   podman.enable = true;
  #   key-remap = { 
  #     enable = true;
  #     caps-to-ctrl-esc = true;
  #     right-alt-to-ctrl-b = true;
  #   };
  # };

  # asahi linux overlay
  nixpkgs.overlays = [ inputs.apple-silicon.overlays.apple-silicon-overlay ];

  # enable GPU support
  hardware.asahi.useExperimentalGPUDriver = true;

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

  system.stateVersion = "23.05";
}

