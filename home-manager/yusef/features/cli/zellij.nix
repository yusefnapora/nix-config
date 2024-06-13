{ pkgs, config, ... }:
let
  colors = config.colorScheme.palette;
  base16-theme = {
    fg = "#${colors.base05}";
    bg = "#${colors.base02}";
    black = "#${colors.base00}";
    red = "#${colors.base08}";
    green = "#${colors.base0B}";
    yellow = "#${colors.base0A}";
    blue = "#${colors.base0D}";
    magenta = "#${colors.base0E}";
    cyan = "#${colors.base0C}";
    white = "#${colors.base05}";
    orange = "#${colors.base09}";
  };
in
{

  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;

    settings = {
      theme = "base16";
      themes.base16 = base16-theme;

      ui.pane_frames = {
        rounded_corners = true;
        hide_session_name = true;
      };
    };
  };
}
