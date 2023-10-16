{ pkgs, config, lib, ... }:
let
  cfg = config.services.speakersafetyd;
  speakersafetyd = pkgs.local-pkgs.speakersafetyd;
in {
  options.services.speakersafetyd = {
    enable = lib.mkEnableOption "Enable speaker safety daemon for asahi linux";
  };

  config = lib.mkIf cfg.enable {

    services.udev.extraRules = ''
      SUBSYSTEM=="sound", DRIVERS=="snd-soc-macaudio", GOTO="speakersafetyd_macaudio"
      GOTO="speakersafetyd_end"

      LABEL="speakersafetyd_macaudio"
      KERNEL=="pcmC*D2c", ATTRS{id}=="J314", TAG+="systemd", ENV{ACP_IGNORE}="1", ENV{SYSTEMD_WANTS}="speakersafetyd.service"
      KERNEL=="pcmC*D2c", ATTRS{id}=="J413", TAG+="systemd", ENV{ACP_IGNORE}="1", ENV{SYSTEMD_WANTS}="speakersafetyd.service"

      LABEL="speakersafetyd_end"
    '';
    
    systemd.services.speakersafetyd = { 
      description = "Speaker safety daemon";
      wantedBy = [ "multi-user.target" ];
      startLimitIntervalSec = 60;
      startLimitBurst = 10;

      serviceConfig = {
        Type = "simple";
        ExecStart = "${speakersafetyd}/bin/speakersafetyd -c ${speakersafetyd}/share/speakersafetyd";
        UMask = "0066";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };
  };
}
