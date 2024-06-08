{ pkgs, config, self, ... }:
let 
  secrets = config.age.secrets;
  home-dir = config.users.users.yusef.home;
  media-dir = "/mnt/rustbucket/Media";
in {

  age.secrets = {
    "restic/nobby-password".file = "${self}/secrets/restic/nobby-password.age";
    "restic/nobby-env".file = "${self}/secrets/restic/nobby-env.age";
    "restic/nobby-repo".file = "${self}/secrets/restic/nobby-repo.age";
  };

  services.restic.backups = {
    daily = { 
      initialize = true;

      environmentFile = secrets."restic/nobby-env".path;
      repositoryFile = secrets."restic/nobby-repo".path;
      passwordFile = secrets."restic/nobby-password".path;

      paths = [
        "${home-dir}/projects"
        "${home-dir}/Documents"

        # TODO: add these once we've tested smaller stuff
        #"${media-dir}/Music recording"
        #"${media-dir}/Home movies"
      ];

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
      ];
    };
  };
}
