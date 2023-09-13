# fix for invisible cursor when running in vmware or nvida gpus
{ config, ... }:
{
  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
