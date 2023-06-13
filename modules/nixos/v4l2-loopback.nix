{ lib, config, ... }:
let
  inherit (lib) mkOption mkEnableOption mkIf types;

  device-submodule = types.submodule {
    options = {
      number = mkOption {
        description = "Device number to assign. will create e.g. /dev/video{number}";
        type = types.ints.unsigned;
      };
      label = mkOption {
        description = "Device label (shown in e.g. Zoom ui to select camera)";
        type = types.str;
      };
    };
  };

  device-number-strs = lib.forEach cfg.devices (c: builtins.toString c.number);
  device-labels = lib.forEach cfg.devices (c: c.label);
  video-nr = lib.concatStringsSep "," device-number-strs;
  label-str = lib.concatStringsSep "," device-labels;
  modprobe-config = ''
    options v4l2loopback exclusive_caps=1 video_nr=${video-nr} device_label=${label-str}
  '';

  cfg = config.v4l2-loopback;
in {
  options.v4l2-loopback = {
    enable = mkEnableOption "Enable video loopback devices with v4l2-loopback";
    devices = mkOption {
      description = "Loopback video devices to create";
      type = types.listOf device-submodule;
    };
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback.out
    ];

    boot.kernelModules = [
        "v4l2loopback"
    ];

    boot.extraModprobeConfig = modprobe-config;
  };
}
