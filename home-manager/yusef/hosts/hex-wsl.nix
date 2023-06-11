{ lib, pkgs, ... }:
{
  imports = [ 
    ../global
    
    (import ../features/desktop/common/fonts.nix {
      inherit lib pkgs;
    })

    ../features/desktop/common/vscode.nix
  ];
}
