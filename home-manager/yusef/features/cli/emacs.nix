{ pkgs, ... }:
{
  # emacs config managed separately in github.com/yusefnapora/emacs.d

  # only install on linux, since we use a mac-hacked emacs via homebrew on darwin
  programs.emacs.enable = pkgs.stdenv.isLinux;
}
