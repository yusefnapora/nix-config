{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOptionDefault;
  mod = "Mod4";
  alt = "Mod1";
  screenshots-dir = "$HOME/Screencaps";
  backgroundImage = config.wallpaper;
in {

  home.packages = [
    pkgs.flameshot
    pkgs.rofi
  ];

  # add pbcopy & pbpaste aliases for clipboard
  programs.fish.shellAliases = {
    pbcopy = "${pkgs.xclip}/bin/xclip -selection clipboard";
    pbpaste = "${pkgs.xclip}/bin/xclip -selection clipboard -o";      
  };

  programs.feh.enable = true;
  xsession.enable = true;
  
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
        modifier = mod;

        gaps = lib.mkDefault {
          inner = 10;
          outer = 5;
        };

        keybindings = mkOptionDefault {
            # terminal
            "${mod}+Return" = "exec $TERMINAL";

            # rofi drun on Mod+d and Mod+Space
            "${mod}+d" = "exec --no-startup-id rofi -show drun";
            "${mod}+space"= "exec --no-startup-id rofi -show drun";

            # rofi emoji picker on Mod+Shift+space
            "${mod}+Shift+space" = "exec --no-startup-id rofi -show emoji";

            # rofi window switcher on Mod+Tab
            "${mod}+Tab" = "exec --no-startup-id rofi -show window";

            # move the default commands for Mod+space and Mod+Shift+space to Mod+o / Mod+Shift+o
            "${mod}+o" = "focus mode_toggle";
            "${mod}+Shift+o" = "floating toggle";

            # screenshots:
            ## PrintScreen and Mod+Shift+S (for keyboards without print screen key) to flameshot gui
            "Print" = "exec flameshot gui -p ${screenshots-dir}";
            "${mod}+Shift+s" = "exec flameshot gui -p ${screenshots-dir}";

            ## Shift+PrintScreen and Mod+Alt+Shift+S to full screen capture
            "Shift+Print" = "exec flameshot full -p ${screenshots-dir}";
            "${mod}+${alt}+Shift+s" = "exec flameshot full -p ${screenshots-dir}";

            # alternative to mod+shift+q, since macos insists on eating it
            "${mod}+Shift+w" = "kill";

            # alternative to mod+w for tabs, since t is for tabs
            "${mod}+t" = "layout tabbed";

            # vim-style focus / movement
            "${mod}+h" = "focus left";
            "${mod}+j" = "focus down";
            "${mod}+k" = "focus up";
            "${mod}+l" = "focus right";
            "${mod}+Shift+h" = "move left";
            "${mod}+Shift+j" = "move down";
            "${mod}+Shift+k" = "move up";
            "${mod}+Shift+l" = "move right";

            # split horizontal moves to Mod+b, since Mod+h is repurposed
            "${mod}+v" = "split v";
            "${mod}+b" = "split h";
        };

        # TODO: use nix-colors
        colors.focused = {
          border = "#00AF91";
          childBorder = "#007965";
          background = "#285577";
          text = "#ffffff";
          indicator = "#2e9ef4";
        };

        # polybar is started by home-manager's systemd service
        bars = [ ];

        startup = [
          { command = "feh --bg-scale --zoom fill ${backgroundImage}"; }
          { command = "i3-msg 'workspace 1'"; }
        ];

        floating.modifier = mod;

        floating.criteria = [
          { title = ".zoom "; }
          { title = "^zoom$"; }
        ];
    };
};
   
}
