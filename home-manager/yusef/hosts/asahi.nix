{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop/common
    ../features/desktop/common/vscode-insiders.nix
    
    ../features/desktop/sway 
    ../features/desktop/sway/natural-scrolling.nix
  ];

  monitors = [
    {
      name = "DP-1";
      width = 3024;
      height = 1890;
      scale = 2.0;
    }
  ];
}
