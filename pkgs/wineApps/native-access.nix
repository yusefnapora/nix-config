# Wine-wrapped "Native Access", used to install software instruments, samples, etc.
# made by Native Instruments. Uses Native Access v1, since v2 doesn't work under wine yet.
{ pkgs
, fetchurl
, fetchzip
, makeDesktopItem
, symlinkJoin
, wrapWine
, ... }:
let

  installer = fetchzip {
    url = "https://www.native-instruments.com/fileadmin/downloads/Native_Access_Installer_211108.zip";
    sha256 = "sha256-3Jq/W51IPtcV1uL/147diZXfX+I0q+dTlHna6j3Q+s0=";
  };

  installer-exe = "Native Access 1.14.1 Setup PC.exe";

  name = "native-access";

  bin = wrapWine {
    inherit name;

    is64bits = true;
    wine = pkgs.wine.override {
      wineBuild = "wineWow";
      wineRelease = "staging";
      tlsSupport = true;
      netapiSupport = true;
    };

    firstrunScript = ''
      echo "installing Native Access"
      # The app seems to like running with version set to win7,
      # but the installer hangs trying to install the ISO driver
      # with less than win10
      winecfg /v win10
      wine "${installer}/${installer-exe}" "/S"
      winecfg /v win7
      echo "installation complete"
    '';

    executable = "$WINEPREFIX/drive_c/Program Files/Native Instruments/Native Access/Native Access.exe";
  };

  desktop = makeDesktopItem {
    name = "Native Access";
    desktopName = "Native Access";
    type = "Application";
    exec = "${bin}/bin/native-access";
  };
in symlinkJoin {
  name = "native-access";
  paths = [bin desktop pkgs.samba];
}
