# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.

{
  # List your module files here
  vscode-server-nix-ld = import ./vscode-server-nix-ld.nix; 
  dual-function-keys = import ./dual-function-keys.nix;
  v4l2-loopback = import ./v4l2-loopback.nix;
  speakersafetyd = import ./speakersafetyd.nix;
}
