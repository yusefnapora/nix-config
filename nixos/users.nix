{ config, pkgs, ... }:
{
    users.users.yusef = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" "onepassword" "video" "libvirtd" ];
        shell = pkgs.fish;

        openssh.authorizedKeys.keys = [ 
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcNEoHJz21abNd7p2go7+nXAOMc9onYQ75MhHUpm1Y5rb1Yrw3ZBOgVgGNriDDa4j3TUgpONid87p1gpUXGpGk+bH9vPLC9rP2icQRDYcpNogJODI5LKnzjZ3ZzVhwc+oel340h4sFUrEkB7NH0A61Yq3wLf4rpnqmj0oREVVNPWUD28nlIokLyNxDByfhZ2xY79lB+FMZkTLoKBgrazFqGH8heZ6mUuKWn97rsTULoNlRtWnEHgh9AjKszRq6tv8s4LzB9i4qB4FROxDjrAWy7UdMK9F6rPuPHjBwin9xYH49sdXN5sDLfWk72iRxFfKd0vVt6H5Uo1OUWzdVrgJd"
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDSwdRPhehw39PvuHYJ0STfFhpTzpYYnSfWUL7YBRVZB0UiBx02zpBpP2cWvuTLkBgU+CwZa+grOvJks4HYNGjpLxprTFry9hPK+W/sGMO0DFqi2ySeHoYTRqb+0/A5IBUQ3dqDUkj3taV3jY2sIZdnu99Eq9vqBG98Wp1vkGGGLHKdaX23pjVTXWoMtnE4SEWGu3IZ4WBfiWJx9uH+Bunr3jklWfcRve/6PeyeJUGBayqKUqgOWLBBH4pva3HVfErPoDBHP6LXfw9TzqWruvnQXpuYBYM1NRIGBSXDuErC35ySCAL9nhASy48Pp3MTcEgH1jgE+Pc3SI8s2UJZGhOU3mHFMhGkgpN1i3iclynKbLHAr2ILbWEhWxLn5zfIqgXg0DXY7hSnDIBr0jURKXs4mQ0pNTxo8jJpVIZtf1jSscLCYb9pAbWFlmeF4W9k67oec/YdKNv9PbdxYHB3HrHSeDzDX6XqyIOtfvH6GieISSOuAsJIf0Bzyzysvc9iEsQbzTh6tS052mh53ITTOYrcUz2bRT1e6++baDQZpUvdaLmECEWsfFXyfCZEbXuqIwHjfcwhGGxn1oJgfRh4LDGsr4V4Lax3KGozv3+qpaAVyjyOzU205uEy5nNam8njJWXNXYDDEBmXld9YTxjGkJVa7NyYA4Yx4gfXN2xffmx2Nw=="
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDI+dmShHHGmqT6Cd1ocgJ+ZPDg8B4kmam9ffcS0VsP"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII280YRFMNNpVO7qxroCmuodMY5Hzo4UwTPoXuukU4tW"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAtGHkPPabyi3Ea1X5qKpOVyzAmkDTf7zHXs7PzIRQjq"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzG8UeYjCrGGSg/Qc0BAfGJnEhg83pjAVzwMJE9RMWU yusef@asahi"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICRYSwy0c0OZ+ZhmZja6o8ZM7gETNAW0b0La5gSrcNhI yusef@nobby"
        ];
    };

    users.users.root.openssh.authorizedKeys.keys =
      config.users.users.yusef.openssh.authorizedKeys.keys;

    # allow running nixos-rebuild as root without a password.
    # requires us to explicitly pull in nixos-rebuild from pkgs, so
    # we get the right path in the sudo config
    environment.systemPackages = [ pkgs.nixos-rebuild ];
    security.sudo.extraRules = [
        {  users = [ "yusef" ];
            commands = [
            { command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
              options = [ "NOPASSWD" "SETENV" ];
            }
            { command = "${pkgs.systemd}/bin/systemctl";
              options = [ "NOPASSWD" "SETENV" ];
            }
            # reboot and shutdown are symlinks to systemctl,
            # but need to be authorized in addition to the systemctl binary
            # to allow nopasswd sudo
            { command = "/run/current-system/sw/bin/shutdown";
              options = [ "NOPASSWD" "SETENV" ];
            }
            { command = "/run/current-system/sw/bin/reboot";
              options = [ "NOPASSWD" "SETENV" ];
            }           
            ];
        }
    ];
}
