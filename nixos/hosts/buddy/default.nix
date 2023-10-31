# Host config for intel nuc used for music production & recording 

{ config, pkgs, lib, inputs, outputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # import module for musnix (music production kernel tuning, etc)
      inputs.musnix.nixosModules.musnix

      ../../common.nix

      # enable various features
      ../../features/sound.nix
      ../../features/tailscale.nix
      ../../features/i3.nix
      ../../features/music-production.nix

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

  hardware.opengl = lib.mkForce {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  
  # display config for LG Ultrafine 5k
  # it's a bit quirky, since it shows up as two displayport outputs
  # that need to be stitched together
  # 
  # This config is equivalent to this xrandr command:
  # xrandr --output DP3 --mode 2560x2880 --output DP4 --mode 2560x2880 --right-of DP3
  services.xserver = {
    videoDrivers = [ "intel" ];
    xrandrHeads = [
      {
        output = "DP3";
        monitorConfig = ''
          Option "PreferredMode" "2560x2880"
        '';
      }
      {
        output = "DP4";
        monitorConfig = ''
          Option "PreferredMode" "2560x2880"
          Option "RightOf" "DP3"
        '';
      }
    ];

    # hi-dpi config
    dpi = 218;
    displayManager.sessionCommands = ''
      ${pkgs.xorg.xrdb}/bin/xrdb -merge <${pkgs.writeText "Xresources" ''
        Xft.dpi: 218
        Xcursor.theme: Adwaita
        Xcursor.size: 48
        Xcursor.theme_core: 1
      ''}
    '';    
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "buddy"; # Define your hostname.

  system.stateVersion = "23.05";
}

