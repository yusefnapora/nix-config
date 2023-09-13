{ lib, config, pkgs, ... }:
let 
  gtk-colors = import ./colors-gtk-css.nix { inherit config; };
  style = gtk-colors + builtins.readFile ./style.css;
in {
  wayland.windowManager.sway.config.bars = [{ command = "waybar"; }];

  programs.waybar = {
    enable = true;
    style = style;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 32;
        modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "tray" "custom/clock" "pulseaudio" "battery" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };

        "custom/clock" = {
          return-type = "json";
          exec =  ''
            text=$(date +'%I:%M %p')
            tt=$(date +'%A, %B %d, %Y')
            echo "{\"text\": \"$text\", \"tooltip\": \"$tt\", \"class\": \"custom-clock\"}"
          '';
          interval = 5;
        };

        clock = {
          format = "{:%I:%M %p}";
          tooltip-format = "{:%A, %B %d, %Y}";
        };

        "wlr/taskbar" = {
          on-click = "activate";
        };

        tray = {
          spacing = 10;
        };

        battery = {
          interval = 60;
          states = {
            warning = 20;
            critical = 10;
          };
          format = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            headphone =  "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
        };
      };
    };
  };
}
