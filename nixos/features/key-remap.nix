{ pkgs
, lib
, caps-to-ctrl-esc ? false
, swap-left-alt-and-super ? false
, right-alt-to-ctrl-b ? false
, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.strings) optionalString concatStringsSep;
  inherit (lib.lists) optionals;

  keys-to-listen-for = 
    optionals caps-to-ctrl-esc ["KEY_CAPSLOCK" "KEY_ESC"] 
    ++ optionals swap-left-alt-and-super [ "KEY_LEFTALT" "KEY_LEFTMETA"]
    ++ optionals right-alt-to-ctrl-b [ "KEY_RIGHTALT" ];


  listen-key-string = (concatStringsSep ", " keys-to-listen-for);
in {
 environment.etc."dual-function-keys.yaml".text = ''
    ---
    MAPPINGS:
    '' + optionalString caps-to-ctrl-esc 
    ''
    # capslock to ctrl when held, esc when tapped
      - KEY: KEY_CAPSLOCK
        TAP: KEY_ESC
        HOLD: KEY_LEFTCTRL
    '' + optionalString swap-left-alt-and-super 
    ''
    # swap left alt and super keys
      - KEY: KEY_LEFTALT
        TAP: KEY_LEFTMETA
        HOLD: KEY_LEFTMETA
        HOLD_START: BEFORE_CONSUME
      - KEY: KEY_LEFTMETA
        TAP: KEY_LEFTALT
        HOLD: KEY_LEFTALT
        HOLD_START: BEFORE_CONSUME
    '' + optionalString right-alt-to-ctrl-b
    ''
    # send ctrl-b when right alt is tapped
      - KEY: KEY_RIGHTALT
        TAP:
          - KEY_LEFTCTRL
          - KEY_B
        HOLD:
          - KEY_LEFTCTRL
          - KEY_B
        HOLD_START: BEFORE_CONSUME
    '';

  services.interception-tools = { 
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /etc/dual-function-keys.yaml | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [${listen-key-string}]
    '';
  };
}