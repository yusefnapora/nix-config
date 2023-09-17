# Host config for 14" M1-Pro macbook pro 

{ config, pkgs, lib, inputs, outputs, ... }:
let asahi-audio = (import ./asahi-audio.nix { inherit pkgs; });
in {
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
      outputs.nixosModules.dual-function-keys
      ../../features/key-mapping/caps-to-ctrl-esc.nix
      ../../features/key-mapping/right-alt-to-ctrl-b.nix

      # loopback video (for virtual webcam)
      outputs.nixosModules.v4l2-loopback
    ];

  home-manager.users.yusef = import ../../../home-manager/yusef/hosts/asahi.nix;

  v4l2-loopback = {
    enable = true;
    devices = [
      {
        number = 0;
        label = "Droidcam";
      }
    ];
  };

  environment.etc."wireplumber/main.lua.d/99-asahi-monitor.lua" = {
    source = "${asahi-audio}/etc/wireplumber/asahi.lua.d/99-asahi-monitor.lua";
    mode = "0644";
  };
  
  environment.etc."wireplumber/policy.lua.d/99-asahi-policy.lua" = {
    source = "${asahi-audio}/etc/wireplumber/asahi.lua.d/99-asahi-policy.lua";
    mode = "0644";
  };

  environment.etc."pipewire/pipewire.conf.d/99-asahi.conf" = {
    source = "${asahi-audio}/etc/wireplumber/asahi.lua.d/99-asahi.conf";
    mode = "0644";
  };

  environment.systemPackages = [ pkgs.droidcam ];
  boot.kernelModules = [ "snd-aloop" ];

  # enable wireplumber
  services.pipewire.wireplumber.enable = true;

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

