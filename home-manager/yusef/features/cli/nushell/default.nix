{ pkgs, config, lib, ... }:
{
  programs.nushell = {
    enable = true;

    envFile.source = ./env.nu;
    configFile.source = ./config.nu;

    extraConfig = lib.optionalString pkgs.stdenv.isDarwin ''
      # use native "open" command on macos
      def nuopen [arg, --raw (-r)] { if $raw { open -r $arg } else { open $arg } }
      alias open = ^open
    '';
  };

  home.packages = builtins.attrValues {
    inherit (pkgs)
      starship
      any-nix-shell
      ;
  };

}
