# enables sway (wayland window manager).
# see home-manager config for all the interesting config bits
{ lib, pkgs, ...}:
{
  environment.systemPackages = [ 
    pkgs.wdisplays 
    pkgs.xorg.xcursorthemes 
    pkgs.vanilla-dmz
    pkgs.xfce.thunar
    pkgs.lxqt.lxqt-policykit # provides a default authentification client for policykit    
    pkgs.qt6.qtwayland
  ];
  programs.sway.enable = true;

  qt.enable = true;
  qt.style = "adwaita";
  qt.platformTheme = "gnome";

  # enable browsing smb shares in thunar, etc
  # see: https://nixos.wiki/wiki/Samba#Browsing_samba_shares_with_GVFS
  services.gvfs.enable = true; 

  # enable gnome keyring so vscode, etc. can store credentials
  services.gnome = {
    gnome-keyring.enable = true;
  };

  # Enable XDG portal for screen capture
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
    wlr = {
      enable = true;
    };
  };
}
