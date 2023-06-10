{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./colors.nix
    ../features/cli
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.nur.overlay
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "yusef";
    homeDirectory = "/home/yusef";
    sessionVariables = {
      EDITOR = "nvim";
      COLORTERM = "truecolor";
    };
  };

  programs.home-manager.enable = true;

  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
