# Baseline "minimal" config, suitable for headless boxes (router, raspberry pi, etc)
# Most hosts extend from ./common.nix instead, which includes quality of life stuff
# like fonts, podman, etc.

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./users.nix
  ];

  home-manager.extraSpecialArgs = { inherit inputs outputs; };

  programs.fish.enable = true;

  services.openssh.enable = true;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # The rest of the configuration is set by each host config, which will
  # import this file and extend to suit each host.
}
