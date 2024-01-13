let
  yusef-keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcNEoHJz21abNd7p2go7+nXAOMc9onYQ75MhHUpm1Y5rb1Yrw3ZBOgVgGNriDDa4j3TUgpONid87p1gpUXGpGk+bH9vPLC9rP2icQRDYcpNogJODI5LKnzjZ3ZzVhwc+oel340h4sFUrEkB7NH0A61Yq3wLf4rpnqmj0oREVVNPWUD28nlIokLyNxDByfhZ2xY79lB+FMZkTLoKBgrazFqGH8heZ6mUuKWn97rsTULoNlRtWnEHgh9AjKszRq6tv8s4LzB9i4qB4FROxDjrAWy7UdMK9F6rPuPHjBwin9xYH49sdXN5sDLfWk72iRxFfKd0vVt6H5Uo1OUWzdVrgJd"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII280YRFMNNpVO7qxroCmuodMY5Hzo4UwTPoXuukU4tW"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAtGHkPPabyi3Ea1X5qKpOVyzAmkDTf7zHXs7PzIRQjq"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE8JtJB3EC/jldJUcScKgJCiiadLn6XBJto79G+mPyzL"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICRYSwy0c0OZ+ZhmZja6o8ZM7gETNAW0b0La5gSrcNhI"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKcE2ufdpALohHDM54J/QJkq1UEDdml6zwyFjgYXUdls"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBeOYgB2H2OtnkiKcJ+x9a5Z3LMzg7hK8OTc72JmMR7g"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGhK0nUmeLqBBZH6rYzJnDZIUb+4k4Nu5HnX8SKDQp46"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPsg702YZAQb1w1zo2Bqky/ypK16FssjxxZCqBPCjhNf"
  ];

  host-keys = {
    sef-macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPi0lvFFKfS1IaqgQr7cnOCKrtF/LDQGLku1RfJ8Jgw7";
    colon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK6oy9VKAAHj9zrX5lf8JWU/hRLCgcYTTI3Zjrg4EjsL";
    nobby = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEiYTgKFzvLaju5krZwlEz6IvwDMlsTLcH7Qlw7a/gRZ";
    buddy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPpyhC+Eq0Z+0JqNZb9cQ0SwdGAsO9pdT1D1FpProSmQ";
  };

  all-hosts = builtins.attrValues host-keys;
in {
  "photoprism-admin.age".publicKeys = yusef-keys ++ [ host-keys.colon ];

  "wireguard-privkey-colon.age".publicKeys = [ host-keys.colon ];
}
