{ config, pkgs, lib, ... }:
let
  inherit (lib.attrsets) attrByPath;

  lock-cmd = "${pkgs.swaylock-effects}/bin/swaylock -S --daemonize";

  lock-timeout = (attrByPath ["SWAY_LOCK_TIMEOUT"] "600" config.home.sessionVariables);
  suspend-timeout = (attrByPath ["SWAY_SUSPEND_TIMEOUT"] "1200" config.home.sessionVariables);

  swayidle-cmd = ''
    ${pkgs.swayidle}/bin/swayidle -w \
      timeout ${lock-timeout} '${lock-cmd}' \
      timeout ${suspend-timeout} 'sudo systemctl suspend' \
      before-sleep '${lock-cmd}' \
      lock '${lock-cmd}'
    '';
in {
  wayland.windowManager.sway.config.startup = [
    { command = swayidle-cmd; }
  ];
}
