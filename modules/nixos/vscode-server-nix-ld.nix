{ pkgs, lib, config, ... }:
let
  inherit (lib) types mkEnableOption mkOption mkIf lists;

  cfg = config.vscode-server-nix-ld;

  NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
    pkgs.stdenv.cc.cc
  ];

  env-setup = ''
    export NIX_LD_LIBRARY_PATH=${NIX_LD_LIBRARY_PATH}
    export NIX_LD=$(cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker | ${pkgs.findutils}/bin/xargs echo -n)
  '';

  user-config-list = lists.forEach cfg.users (user: {
    name = user;
    value = {
      home.file.".vscode-server/server-env-setup".text = env-setup;
    };
  });

  user-configs = builtins.listToAttrs user-config-list;
in {

  options.vscode-server-nix-ld = with types; {
    enable = mkEnableOption "Enable nix-ld based support for vscode server. The home-manager nixos module must be installed for this to work correctly.";
    users = mkOption {
      type = types.listOf types.str;
      description = "Users to enable vscode-server support for.";
      example = "[ \"yusef\" ]";
      default = [];
    };
  };

  config = mkIf cfg.enable {
    programs.nix-ld.enable = true;
    environment.systemPackages = [ pkgs.wget ];
    home-manager.users = user-configs;
  };
}

