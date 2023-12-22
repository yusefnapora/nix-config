# adapted from https://github.com/bphenriques/dotfiles/blob/master/nixos/modules/services/sunshine.nix
{ config, lib, pkgs, ... }:
let sunshine-pkg = pkgs.sunshine.override { cudaSupport = true; stdenv = pkgs.cudaPackages.backendStdenv; };
in
with lib;
{

  # From https://docs.lizardbyte.dev/projects/sunshine/en/latest/about/usage.html#linux
  # https://docs.lizardbyte.dev/projects/sunshine/en/latest/about/advanced_usage.html#port
  networking.firewall = {
    allowedTCPPorts = [ 47984 47989 47990 48010 ];
    allowedUDPPorts = [ 47998 47999 48000 48002 ];
  };

  # Make it work for KMS.
  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+p";
    source = "${sunshine-pkg}/bin/sunshine";
  };

  # Requires to simulate input
  boot.kernelModules = [ "uinput" ];
  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
  '';

  environment.systemPackages = [ sunshine-pkg ];
  #systemd.packages = with pkgs; [ sunshine ];

  systemd.user.services.sunshine-temp-v5 = {
    enable = true;
    description = "Starts Sunshine";
    wantedBy = ["graphical-session.target"];
    startLimitIntervalSec = 500;
    startLimitBurst = 5;
    serviceConfig = {
       Restart = "on-failure";
       RestartSec = 5;
       ExecStart = "${sunshine-pkg}/bin/sunshine";
     };
  };
}
