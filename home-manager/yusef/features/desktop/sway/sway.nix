{ lib
, config
, pkgs
, inputs
, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.lists) optionals;
  inherit (lib.strings) optionalString;

  output-config = (import ./monitors.nix {
    inherit lib;
    inherit (config) monitors;
  });

  cursor-size = 24;
  
  background-image = config.wallpaper;
  lock-cmd = "${pkgs.swaylock-effects}/bin/swaylock -S --daemonize";

  start-sway = pkgs.writeShellScriptBin "start-sway" ''
    exec ${pkgs.dbus}/bin/dbus-run-session sway $SWAY_CLI_FLAGS
  '';

  color-config = with config.colorScheme.colors; ''
    # class                 border     backgr.    text       indicator    child_border
    client.focused          #${base04} #${base0D} #${base02} #${base0E}   #${base0D}
    client.focused_inactive #${base02} #${base02} #${base06} #${base0E}   #${base0E}
    client.unfocused        #${base02} #${base01} #${base07} #${base04}   #${base04}
    client.urgent           #${base0A} #${base09} #${base01} #${base04}   #${base0A}
    client.placeholder      #${base00} #${base04} #${base07} #${base00}   #${base04}

    client.background       #${base00}
  '';

in {

  imports = [
    ./waybar
    ./swaylock.nix
    ./electron-hacks.nix
    ./mako.nix
  ];

  programs.fish.loginShellInit = ''
    # if running from tty1, start sway
    set TTY1 (tty)
    
    if [ "$TTY1" = "/dev/tty1" ]
      exec ${start-sway}/bin/start-sway 
    end
  '';

  home.packages = builtins.attrValues {
    inherit (pkgs) wl-clipboard albert;
  };

  # add pbcopy & pbpaste aliases for clipboard
  programs.fish.shellAliases = {
    pbcopy = "${pkgs.wl-clipboard}/bin/wl-copy";
    pbpaste = "${pkgs.wl-clipboard}/bin/wl-paste";
  };

  wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;

      config = { 
        modifier = "Mod4";
        terminal = config.home.sessionVariables.TERMINAL;
        output = output-config // {
          "*" = {
            bg = "${background-image} fill";
          };
        };
        window.hideEdgeBorders = "both";
        fonts = {
          names = [ "FiraCode Nerd Font" ];
          style = "Regular";
          size = 12.0;
        };

        keybindings = 
          let
            modifier = config.wayland.windowManager.sway.config.modifier;
          in lib.mkOptionDefault {
            "${modifier}+space" = "exec ${pkgs.albert}/bin/albert show";
            "${modifier}+Shift+slash" = "exec ${lock-cmd}";
            "${modifier}+n" = "exec firefox";
            "${modifier}+Shift+n" = "exec firefox --private-window";
            "${modifier}+Shift+k" = "kill";
            "${modifier}+t" = "layout tabbed";
          };

        focus.wrapping = "no";

        startup = [
          { command = "eval $(gnome-keyring-daemon --start --components=secrets);"; }
          { command = "${pkgs.albert}/bin/albert"; }
        ];

        # set cursor size
        seat."*".xcursor_theme = "Vanilla-DMZ ${builtins.toString cursor-size}";
      };

      systemd.enable = true;

      extraConfig = color-config;

      extraSessionCommands = ''
        export QT_AUTO_SCREN_SCALING_FACTOR=1 
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOW_DECORATIONS=1
        export GDK_BACKEND=wayland
        export MOZ_ENABLE_WAYLAND=1
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
  };

  # cursor config
  home.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = cursor-size;
    gtk.enable = true;
  };
}
