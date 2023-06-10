{ lib, pkgs, config, ... }:
let
  inherit (config.colorScheme) colors;
in {
  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 14;
      font.normal.family = "FiraCode Nerd Font Mono";
      font.bold.family = "FiraCode Nerd Font Mono";

      colors = {
        primary = {
          foreground = "#${colors.base05}";
          background = "#${colors.base00}";
        };
      
        # Colors the cursor will use if `custom_cursor_colors` is true
        cursor = {
          text = "#${colors.base00}";
          cursor = "#${colors.base05}";
        };
    
        # Normal colors
        normal = {
          black = "#${colors.base00}";
          red = "#${colors.base08}";
          green =   "#${colors.base0B}";
          yellow = "#${colors.base0A}";
          blue = "#${colors.base0D}";
          magenta = "#${colors.base0E}";
          cyan = "#${colors.base0C}";
          white = "#${colors.base05}";
        };
        # Bright colors
        bright = {
          black = "#${colors.base03}";
          red = "#${colors.base09}";
          green = "#${colors.base01}";
          yellow = "#${colors.base02}";
          blue = "#${colors.base04}";
          magenta = "#${colors.base06}";
          cyan = "#${colors.base0F}";
          white = "#${colors.base07}";
       };
       draw_bold_text_with_bright_colors = false;
      };
    };
  };
}
