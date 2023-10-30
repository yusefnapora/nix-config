{ pkgs, inputs, ... }:
{
  imports = [
    inputs.musnix.nixosModules.musnix
  ];

  musnix.enable = true;
  musnix.kernel.realtime = true;
  musnix.das_watchdog.enable = true;

  environment.systemPackages = builtins.attrValues { 
    inherit (pkgs)
      reaper
      odin2
      tunefish
      ;
    inherit (pkgs.local-pkgs) airwave;
  };

}
