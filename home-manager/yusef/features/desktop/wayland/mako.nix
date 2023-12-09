{ config, pkgs, ... }:
let colors = config.colorScheme.colors;
in {
  services.mako = {
    enable = true;
    icons = true;
    anchor = "bottom-right";
    margin = "30";
    padding = "20";
    borderRadius = 5;
    backgroundColor = "#${colors.base01}";
    textColor = "#${colors.base05}";
    borderColor = "#${colors.base04}";
  };
}
