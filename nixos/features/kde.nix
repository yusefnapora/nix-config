# Enables KDE plasma
{ pkgs, lib, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    displayManager.defaultSession = "plasmawayland";
    desktopManager.plasma5.enable = true;
  };

  programs.dconf.enable = true;
}