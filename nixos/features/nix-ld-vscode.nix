{ pkgs, lib, ... }:
let
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
      pkgs.stdenv.cc.cc
    ];
in {

  programs.nix-ld.enable = true;
  environment.systemPackages = [ pkgs.wget ];
  home-manager.users.yusef.home.file.".vscode-server/server-env-setup".text = ''
    export NIX_LD_LIBRARY_PATH=${NIX_LD_LIBRARY_PATH}
    export NIX_LD=$(cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker | xargs echo -n)
  '';
}
