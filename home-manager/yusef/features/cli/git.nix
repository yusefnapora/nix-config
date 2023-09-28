{ config, pkgs, ... }:
{
    home.file.".config/git/config-sharefile.inc".text = ''
      [user]
        email = "yusef.napora@citrix.com"
    '';

    programs.git = { 
        enable = true;
        userName = "Yusef Napora";
        userEmail = "yusef@napora.org";
        aliases = {
            upstream-name = "!git remote | egrep -o '(upstream|origin)' | tail -1";
            head-branch = "!basename $(git symbolic-ref refs/remotes/$(git upstream-name)/HEAD)";
            cm = "!git checkout $(git head-branch)";
            co = "checkout";
            cob = "checkout -b";
            repo-root = "rev-parse --show-toplevel";
            rr = "rev-parse --show-toplevel";
        };

        includes = [
            { path = "~/.config/git/config-sharefile.inc"; 
              condition = "gitdir:~/work";
            }
        ];

        ignores = [
            ".env"
            ".envrc"
            ".direnv/"
            "*.swp"
            ".idea/"
        ];

        extraConfig = {
            init.defaultBranch = "main";
        };

        difftastic = { 
          enable = true;
          background = "${config.colorScheme.kind}"; 
        };
    };
}
