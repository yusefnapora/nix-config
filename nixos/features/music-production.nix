{ pkgs, inputs, ... }:
let
  inherit (pkgs.lib.lists) optionals;
in {
  imports = [
    inputs.musnix.nixosModules.musnix
  ];

  musnix = {
    enable = true;
    alsaSeq.enable = true;
    kernel.realtime = true;
    das_watchdog.enable = true;
  };
  environment.systemPackages = builtins.attrValues { 
    inherit (pkgs)
      reaper
      odin2
      tunefish
      yabridge
      yabridgectl
      libjack2
      jack2
      jack2Full
      jack_capture
      qjackctl
      a2jmidid
      pavucontrol
      guitarix
      gxplugins-lv2
      rakarrack
      rkrlv2
      distrho
      kapitonov-plugins-pack
      carla
      lsp-plugins
      ;
  };

}
