{ pkgs, lib, ... }:
let
  inherit (pkgs.stdenv) system;

  sources = {
    x86_64-linux = {
      os = "linux-x64";
      sha256 = "";
    };
    aarch64-linux = {
      os = "linux-arm64";
      sha256 = "1723n1dd7y8lp0495g8x9n3ipbwlhly0xwv2bv4klhgd8vfd8fzf";
    };
  };

  os = sources.${system}.os;
  sha256 = sources.${system}.sha256;

  src = builtins.fetchTarball {
    url = "https://code.visualstudio.com/sha/download?build=insider&os=${os}";
    sha256 = sha256;
  };

  vscode-insiders = (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (
    oldAttrs: rec {
      inherit src;
      version = "latest";
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
    });
in {
  programs.vscode = {
    enable = true;
    package = vscode-insiders.fhs;
  };
}
