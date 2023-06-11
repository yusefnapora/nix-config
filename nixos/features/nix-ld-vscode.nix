{ pkgs, lib, outputs, ... }:
{
  imports = [
    outputs.nixosModules.vscode-server-nix-ld
  ];

  vscode-server-nix-ld = {
    enable = true;
    users = [ "yusef" ];
  };
}
