{ config, pkgs, ...}:
let asahi-audio = (import ./asahi-audio.nix { inherit pkgs; });
in {

  # enable wireplumber
  services.pipewire.wireplumber.enable = true;

  # enable speaker device tree (14" 2021 MBP only)
  boot.kernelPatches = [{ 
    name = "enable-j314-speakers";
    patch = ./enable-j314-speakers.patch;
  }];

  # copy wireplumber config into place.
  environment.etc."wireplumber/asahi.lua.d/99-asahi-monitor.lua" = {
    source = "${asahi-audio}/etc/wireplumber/main.lua.d/99-asahi-monitor.lua";
    mode = "0644";
  };
  
  environment.etc."wireplumber/asahi.lua.d/99-asahi-policy.lua" = {
    source = "${asahi-audio}/etc/wireplumber/policy.lua.d/99-asahi-policy.lua";
    mode = "0644";
  };

  environment.etc."pipewire/pipewire.conf.d/99-asahi.conf" = {
    source = "${asahi-audio}/etc/pipewire/pipewire.conf.d/99-asahi.conf";
    mode = "0644";
  };

}
