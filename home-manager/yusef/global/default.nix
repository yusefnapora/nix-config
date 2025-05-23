{ inputs, outputs, lib, config, pkgs, ... }: 
let
  inherit (pkgs.stdenv) isDarwin;
  homeDirectory = if isDarwin then "/Users/yusef" else "/home/yusef";
in
{
  imports = [
    ./colors.nix
    ../features/cli
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.nur.overlays.default
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [ 
        "electron-27.3.11"
      ];
    };
  };

  home = {
    username = lib.mkDefault "yusef";
    homeDirectory = lib.mkDefault homeDirectory;
    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = lib.mkDefault "wezterm";
      COLORTERM = lib.mkDefault "truecolor";
      BROWSER = lib.mkDefault "firefox";
    };
  };

  programs.home-manager.enable = true;

  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
