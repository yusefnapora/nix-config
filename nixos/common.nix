# Extends minimal config to include features we almost always want (fonts, etc.) 
{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    ./minimal.nix

    # features we always want
    ./features/fonts.nix
    ./features/podman.nix
  ];

  # The rest of the configuration is set by each host config, which will
  # import this file and extend to suit each host.
}
