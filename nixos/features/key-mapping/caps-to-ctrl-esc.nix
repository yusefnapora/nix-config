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
    mappings."Capslock to Esc when tapped, Ctrl when held" = {
      key = "KEY_CAPSLOCK";
      tap = "KEY_ESC";
      hold = "KEY_LEFTCTRL";
    };
  };
}
