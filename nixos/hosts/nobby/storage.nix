{ pkgs, ... }:
{

  fileSystems."/mnt/rustbucket" =
    { device = "/dev/disk/by-uuid/B26A85D86A859A2D";
      fsType = "ntfs3";
      noCheck = true;
      options = [ "rw" "uid=1000" "nofail" ];
    };


  fileSystems."/mnt/disks/storage-1" = {
    device = "/dev/disk/by-label/storage-1-20tb";
    fsType = "btrfs";
    options = [ "compress=zstd" ];
  };

  fileSystems."/mnt/parity/parity-1" = {
    device = "/dev/disk/by-label/parity-1-20tb";
    fsType = "ext4";
  };

  # TODO: setup mergerfs once we have more disks onliine
  # environment.systemPackages = [ pkgs.mergerfs ];

  # fileSystems."/storage" = {
  #  fsType = "fuse.mergerfs";
  #  device = "/mnt/disks/*";
  # };

}
