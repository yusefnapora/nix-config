{ pkgs
, lib
, config
, ...}:
let
  inherit (lib) mkEnableOption mkOption mkIf types;
  inherit (lib.strings) optionalString concatStringsSep;
  inherit (lib.lists) optionals;
  inherit (lib.generators) toYAML;

  mapping-submodule = with types; types.submodule {
    options = {
      key = mkOption {
        type = str;
        description = "Key code of key that triggers the event (physical key being pressed)";
        example = "KEY_CAPSLOCK";
      };

      tap = mkOption {
        type = oneOf [str (listOf str)];
        description = "Key code to send when key is tapped";
        example = "KEY_LEFTCTRL";
      };

      hold = mkOption {
        type = oneOf [str (listOf str)];
        description = "Key code to send when key is held";
        example = "KEY_ESC";
      };

      hold-start = mkOption {
        type = nullOr (oneOf [str (listOf str)]);
        description = "Honestly can't remember... check interception-tools docs later :)";
        default = null;
      };
    };
  };

  cfg = config.key-remapping.dual-function-keys;
  mapping-values = builtins.attrValues cfg.mappings;

  input-keys = lib.forEach mapping-values (m: m.key);
  listen-key-string = (concatStringsSep ", " input-keys);

  mappings = lib.forEach mapping-values (m: {
    KEY = m.key;
    TAP = m.tap;
    HOLD = m.hold;
  } // lib.optionalAttrs (m.hold-start != null) {
    HOLD_START = m.hold-start;
  });

  config-yaml = toYAML {} {
    MAPPINGS = mappings;
  };

  config-file = pkgs.writeText "dual-function-keys.yaml" config-yaml;

in {

  options.key-remapping.dual-function-keys = {
    enable = mkEnableOption "Enable configuration of dual-function keys using interception-tools";

    mappings = mkOption {
      type = types.attrsOf mapping-submodule;
      description = "Key mapping definitions";
      default = {};
    };
  };

  config = {
    services.interception-tools = { 
      enable = true;
      plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
      udevmonConfig = ''
        - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c ${config-file} | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [${listen-key-string}]
      '';
    };
  };
}