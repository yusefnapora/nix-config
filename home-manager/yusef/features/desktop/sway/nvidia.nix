{ pkgs, config, lib, ... }:
{
  home.sessionVariables = {
    SWAY_CLI_FLAGS = "--unsupported-gpu";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    WLR_DRM_NO_ATOMIC = "1";
  };

  
}
