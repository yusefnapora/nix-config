{ config, lib, pkgs, ... }:
let 
  mkFontOption = kind: {
    family = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "Family name for ${kind} font profile";
      example = "Fira Code";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = null;
      description = "Package for ${kind} font profile";
      example = "pkgs.fira-code";
    };
  };
  cfg = config.fontProfiles;
in {
  
  options.fontProfiles = {
    monospace = mkFontOption "monospace";
    regular = mkFontOption "regular";
  };


  config = {
    fontProfiles = {
      monospace = {
        family = "FiraCode Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
      };
      regular = {
        family = "Fira Sans";
        package = pkgs.fira;
      };
    };
  };
}
