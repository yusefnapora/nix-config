{ pkgs, ... }:
{
  # disable default sound module. see https://nixos.wiki/wiki/PipeWire
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
  };

  environment.etc."wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
  '';

  environment.systemPackages = builtins.attrValues { inherit (pkgs) pavucontrol alsa-utils; };
}