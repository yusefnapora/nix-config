{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop/common/wezterm.nix
  ];

  home.username = lib.mkForce "ynapora";
  home.homeDirectory = lib.mkForce "/Users/ynapora";

  programs.ssh.matchBlocks = {
    "code.citrite.net" = {
      identityFile = "/Users/ynapora/.ssh/pdm-git-rsa__code-citrite-net";
      user = "git";
    };
    "ssh.code.sharefile-coretools.com" = {
      identityFile = "/Users/ynapora/.ssh/pdm-git-rsa__ssh-code-sharefile-coretools-com";
      user = "git";
    };
  };

  programs.fish.plugins = [
    {
      name = "nvm";
      src = pkgs.fetchFromGitHub {
        owner = "jorgebucaran";
        repo = "nvm.fish";
        rev = "a0892d0bb2304162d5faff561f030bb418cac34d";
        sha256 = "sha256-GTEkCm+OtxMS3zJI5gnFvvObkrpepq1349/LcEPQRDo=";
      };
    }
  ];
}
