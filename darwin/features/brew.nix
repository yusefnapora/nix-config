{ pkgs, config, ... }:
{
  homebrew = {
    enable = true;

    taps = [
      "d12frosted/emacs-plus"
    ];
    brews = [
      "d12frosted/emacs-plus/emacs-plus@29"
    ];
  };
}
