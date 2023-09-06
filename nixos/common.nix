# Extends minimal config to include features we almost always want (fonts, etc.) 
{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./minimal.nix

    ./features/fonts.nix
    #./features/podman.nix
    ./features/nix-ld-vscode.nix
  ];

  

  # The rest of the configuration is set by each host config, which will
  # import this file and extend to suit each host.
}
