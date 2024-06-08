# adapted from https://github.com/bphenriques/dotfiles/blob/master/nixos/modules/services/sunshine.nix
{ config, lib, pkgs, ... }:
{

  services.sunshine = {
    enable = true;
    package = pkgs.sunshine.override { cudaSupport = true; };
    capSysAdmin = true;
    openFirewall = true;
  };
}
