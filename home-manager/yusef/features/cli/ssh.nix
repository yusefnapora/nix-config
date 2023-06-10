{ ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent=yes
    '';

    matchBlocks = {
      sb = {
        hostname = "proton.usbx.me";
        user = "yusef";
      };

      # WSL on hex via proxy jump config
      # see https://kleinfelter.com/3-ways-to-ssh-to-a-pc-running-windows-and-wsl2
      hex-wsl = {
        hostname = "127.0.0.1";
        port = 2022;
        proxyJump = "hex-win";
        user = "yusef";
      };

      # Hex (windows host). LAN only
      hex-win = {
        hostname = "hex.lan";
        user = "yusef";
      };
    };
  };
}