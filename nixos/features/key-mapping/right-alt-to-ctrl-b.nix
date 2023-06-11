# depends on the key-remapping module. add this to your host config:
# imports = [ 
#   outputs.nixosModules.dual-function-keys
#   # whatever other imports you want
# ];
#
{...}:
{
  key-remapping.dual-function-keys = {
    enable = true;
    mappings."Right Alt to Ctrl+B" = {
      key = "KEY_RIGHTALT";
      tap = ["KEY_LEFTCTRL" "KEY_B"];
      hold = ["KEY_LEFTCTRL" "KEY_B"];
      hold-start = "BEFORE_CONSUME";
    };
  };
}
