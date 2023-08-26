# enables i3 tiling X11 window manager
# see home-manager config for all the interesting config bits
{ lib, pkgs, ...}:
{
  services.xserver = {
    enable = true;
    libinput.enable = true;

    displayManager.defaultSession = "none+i3";
    windowManager.i3.enable = true;
  };

}
