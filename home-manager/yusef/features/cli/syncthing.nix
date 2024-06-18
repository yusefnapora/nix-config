{ pkgs, config, ... }:
{

  services.syncthing = {
    enable = true;

    # TODO: look into extraOptions
  };

}
