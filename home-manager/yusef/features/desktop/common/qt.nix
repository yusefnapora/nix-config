{ config, ... }:
let
  style = if config.colorScheme.variant == "dark" then "adwaita-dark" else "adwaita";
in
{
  qt.enable = true;
  qt.style.name = style;
  qt.platformTheme = "gnome";
}
