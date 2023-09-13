{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop/common

    # not using default sway config, since I don't want swayidle to lock the session
    # in the VM when I page away to the host for a while.
    ../features/desktop/sway/sway.nix
    ../features/desktop/sway/no-hardware-cursors.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.snazzy;

  monitors = [
    {
      name = "Virtual-1";
      width = 3072;
      height = 1920;
      scale = 2.0;
    }
  ];
}
