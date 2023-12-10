{ pkgs, lib, config, inputs, ... }:
let
  mod = "SUPER";
  swaylock = "${config.programs.swaylock.package}/bin/swaylock";
  terminal = config.home.sessionVariables.TERMINAL;
  browser = config.home.sessionVariables.BROWSER;
  wofi = "${config.programs.wofi.package}/bin/wofi";
in
{

  imports = [
    ../wayland
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs) kitty dolphin wofi;
  };

  #xdg.portal = {
  #  extraPortals = [ inputs.hyprland.xdg-desktop-portal-hyprland ];
  #  configPackages = [ inputs.hyprland.hyprland ];
  #};

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitor = ",preferred,auto,auto";

      env = [
        "XCURSOR_SIZE,24"
      ];

      exec = [
        "${pkgs.swaybg}/bin/swaybg -i ${config.wallpaper} --mode fill"
      ];

      bind = [
        # program keybinds
        "${mod},Return,exec,${terminal}"
        "${mod},n,exec,${browser}"
        "${mod},Space,exec,${wofi} -S drun"

        # hyprland controls
        "${mod} SHIFT, e, exit,"

        # window management
        "${mod}, V, togglefloating,"
        
        # Move focus with mainMod + arrow keys
        "${mod}, left, movefocus, l"
        "${mod}, right, movefocus, r"
        "${mod}, up, movefocus, u"
        "${mod}, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "${mod}, 1, workspace, 1"
        "${mod}, 2, workspace, 2"
        "${mod}, 3, workspace, 3"
        "${mod}, 4, workspace, 4"
        "${mod}, 5, workspace, 5"
        "${mod}, 6, workspace, 6"
        "${mod}, 7, workspace, 7"
        "${mod}, 8, workspace, 8"
        "${mod}, 9, workspace, 9"
        "${mod}, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "${mod} SHIFT, 1, movetoworkspace, 1"
        "${mod} SHIFT, 2, movetoworkspace, 2"
        "${mod} SHIFT, 3, movetoworkspace, 3"
        "${mod} SHIFT, 4, movetoworkspace, 4"
        "${mod} SHIFT, 5, movetoworkspace, 5"
        "${mod} SHIFT, 6, movetoworkspace, 6"
        "${mod} SHIFT, 7, movetoworkspace, 7"
        "${mod} SHIFT, 8, movetoworkspace, 8"
        "${mod} SHIFT, 9, movetoworkspace, 9"
        "${mod} SHIFT, 0, movetoworkspace, 10"

        # Scroll through existing workspaces with mainMod + scroll
        "${mod}, mouse_down, workspace, e+1"
        "${mod}, mouse_up, workspace, e-1"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "${mod}, mouse:272, movewindow"
        "${mod}, mouse:273, resizewindow"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
        touchpad.disable_while_typing = false;
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "0xff${config.colorscheme.colors.base0C}";
        "col.inactive_border" = "0xff${config.colorscheme.colors.base02}";
      };
      group = {
        "col.border_active" = "0xff${config.colorscheme.colors.base0B}";
        "col.border_inactive" = "0xff${config.colorscheme.colors.base04}";
        groupbar = {
          font_size = 11;
        };
      };
      misc = {
        vfr = true;
        close_special_on_empty = true;
        # Unfullscreen when opening something
        new_window_takes_over_fullscreen = 2;
      };
      decoration = {
        active_opacity = 0.94;
        inactive_opacity = 0.75;
        fullscreen_opacity = 1.0;
        rounding = 5;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
        };
        drop_shadow = true;
        shadow_range = 12;
        shadow_offset = "3 3";
        "col.shadow" = "0x44000000";
        "col.shadow_inactive" = "0x66000000";
      };
      layerrule = [
        "blur,waybar"
        "ignorezero,waybar"
      ];
      blurls = [
        "waybar"
      ];
      animations = {
        enabled = true;
        bezier = [
          "easein,0.11, 0, 0.5, 0"
          "easeout,0.5, 1, 0.89, 1"
          "easeinback,0.36, 0, 0.66, -0.56"
          "easeoutback,0.34, 1.56, 0.64, 1"
        ];

        animation = [
          "windowsIn,1,3,easeoutback,slide"
          "windowsOut,1,3,easeinback,slide"
          "windowsMove,1,3,easeoutback"
          "workspaces,1,2,easeoutback,slide"
          "fadeIn,1,3,easeout"
          "fadeOut,1,3,easein"
          "fadeSwitch,1,3,easeout"
          "fadeShadow,1,3,easeout"
          "fadeDim,1,3,easeout"
          "border,1,3,easeout"
        ];
      };
    };
  };
}
