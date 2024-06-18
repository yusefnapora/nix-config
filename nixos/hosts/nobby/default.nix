{ lib, config, pkgs, inputs, outputs, ... }:
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
      ../../features/kde.nix
      ../../features/kindle
      ../../features/steam.nix
      ../../features/sunshine.nix
      ../../features/plex-server.nix

      # key remapping
      outputs.nixosModules.dual-function-keys
      ../../features/key-mapping/caps-to-ctrl-esc.nix


      # local smb shares
      ./samba.nix

      # restic backup to Backblaze B2
      ./restic.nix
    ];


  programs.hyprland.enable = true;

  home-manager.users.yusef = import ../../../home-manager/yusef/hosts/nobby.nix;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) pciutils usbutils cudatoolkit zfs btrfs-progs btrfs-snap;
  };

  # nvidia GPU setup
  hardware.nvidia = {
    # use open-source driver
    #open = true;
    #package = config.boot.kernelPackages.nvidiaPackages.beta;

    # use beta driver until 555 hits nixpkgs unstable (less glitchy, esp for xwayland)
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "555.42.02";
      sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
      sha256_aarch64 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
      openSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
      settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA="; 
      persistencedSha256 = lib.fakeSha256;
    };

    modesetting.enable = true;
    powerManagement.enable = true;
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      nvidia-vaapi-driver
    ];
  };


  # Fix for stupid nvidia wayland bug: https://github.com/NixOS/nixpkgs/issues/202454#issuecomment-1579609974
  #  environment.etc."egl/egl_external_platform.d".source = let
  #  nvidia_wayland = pkgs.writeText "10_nvidia_wayland.json" ''
  #    {
  #        "file_format_version" : "1.0.0",
  #        "ICD" : {
  #            "library_path" : "${inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.egl-wayland}/lib/libnvidia-egl-wayland.so"
  #        }
  #    }
  #  '';
  #  nvidia_gbm = pkgs.writeText "15_nvidia_gbm.json" ''
  #    {
  #        "file_format_version" : "1.0.0",
  #        "ICD" : {
  #            "library_path" : "${config.hardware.nvidia.package}/lib/libnvidia-egl-gbm.so.1"
  #        }
  #    }
  #  '';
  #in
  #  lib.mkForce (pkgs.runCommandLocal "nvidia-egl-hack" {} ''
  #    mkdir -p $out
  #    cp ${nvidia_wayland} $out/10_nvidia_wayland.json
  #    cp ${nvidia_gbm} $out/15_nvidia_gbm.json
  #  '');


  services.xserver.videoDrivers = [ "nvidia" ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  # Use grub instead of systemd-boot so we can use the OS prober to find Windows
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nobby"; # Define your hostname.
  networking.hostId = "b3e05958";

  # enable DHCP for all interfaces, since my usb ethernet adapter sometimes
  # gets its "predictable" name changed depending on what else is plugged in
  # at boot 
  networking.useDHCP = true;

  system.stateVersion = "22.11";
}

