{ lib, pkgs, config, ... }:
{
  imports = [ 
    ../global
    
    (import ../features/desktop/common/fonts.nix {
      inherit lib pkgs config;
    })

    ../features/desktop/common/vscode.nix
    ../features/desktop/common/wezterm.nix
  ];

}
