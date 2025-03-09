# enables i3 tiling X11 window manager
# see home-manager config for all the interesting config bits
{ lib, pkgs, ...}:
{
  services.xserver = {
    enable = true;

    windowManager.i3.enable = true;
  };


  services.displayManager.defaultSession = "none+i3";
  services.libinput.enable = true;
}
