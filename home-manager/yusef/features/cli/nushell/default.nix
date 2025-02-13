{ pkgs, config, lib, ... }:
{
  programs.nushell = {
    enable = true;

    envFile.source = ./env.nu;
    configFile.source = ./config.nu;

    extraConfig = lib.optionalString pkgs.stdenv.isDarwin ''
      # add alias for macos `open` command 
      alias macopen = /usr/bin/open
    '';
  };

  home.packages = builtins.attrValues {
    inherit (pkgs)
      starship
      any-nix-shell
      ;
  };

}
