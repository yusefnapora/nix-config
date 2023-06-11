{ lib, pkgs, config, modulesPath, inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl

    ../../common.nix
  ];

  
  home-manager.users.yusef = import ../../../home-manager/yusef/hosts/hex-wsl.nix;

  wsl = {
    enable = true;
    defaultUser = "yusef";
    startMenuLaunchers = true;
    nativeSystemd = true;

    wslConf.interop.appendWindowsPath = false;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };


  programs.fish.shellInit = ''
  # set DISPLAY to host IP:0 to use X410 instead of WSLg
  # motivation: X410 supports window snapping / fancy zones / komorebi, etc.
  # revisit if this is fixed: https://github.com/microsoft/wslg/issues/22
  # WSLg should be disabled (https://x410.dev/cookbook/wsl/disabling-wslg-or-using-it-together-with-x410)
  # unless you need it for wayland
  set -x DISPLAY (grep nameserver /etc/resolv.conf | sed 's/nameserver //'):0

  # prefer to use linux vscode from cli
  set -x DONT_PROMPT_WSL_INSTALL true
  '';

  # enable gnome-keyring
  services.gnome = {
    gnome-keyring.enable = true;
  };


  systemd.services.nixos-wsl-systemd-fix = {
    description = "Fix the /dev/shm symlink to be a mount";
    unitConfig = {
      DefaultDependencies = "no";
      Before = [ "sysinit.target" "systemd-tmpfiles-setup-dev.service" "systemd-tmpfiles-setup.service" "systemd-sysctl.service" ];
      ConditionPathExists = "/dev/shm";
      ConditionPathIsSymbolicLink = "/dev/shm";
      ConditionPathIsMountPoint = "/run/shm";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${pkgs.coreutils-full}/bin/rm /dev/shm"
        "/run/wrappers/bin/mount --bind -o X-mount.mkdir /run/shm /dev/shm"
      ];
    };
    wantedBy = [ "sysinit.target" ];
  };

  programs.dconf.enable = true;
  security.pam.services.xdm.enableGnomeKeyring = true;

  programs.ssh.startAgent = true;
  services.openssh.ports = [ 2022 ];
  
  networking.hostName = "Hex";

  system.stateVersion = "22.05";

}
