# depends on the key-remapping module. add this to your host config:
# imports = [ 
#   outputs.nixosModules.dual-function-keys
#   # whatever other imports you want
# ];
#
{ ...}:
{
  key-remapping.dual-function-keys = {
    enable = true;
    mappings."Left Alt to Left Super" = {
      key = "KEY_LEFTALT";
      tap = "KEY_LEFTMETA";
      hold = "KEY_LEFTMETA";
      hold-start = "BEFORE_CONSUME";
    };
    mappings."Left Super to Left Alt" = {
      key = "KEY_LEFTMETA";
      tap = "KEY_LEFTALT";
      hold = "KEY_LEFTALT";
      hold-start = "BEFORE_CONSUME";
    };
  };
}
