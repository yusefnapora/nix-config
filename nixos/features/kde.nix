# Enables KDE plasma
{ pkgs, lib, ... }:
{
  services.xserver.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.dconf.enable = true;
}
