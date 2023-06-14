# Package for Kindle v1.17, the last version before KFX downloads were added.
# Note that the system trust store needs to have a specific verisign root certificate
# installed. See nixos/features/kindle/default.nix in this repo for that bit, plus
# a script to extract the decryption key from the installed app.

{ pkgs
, fetchurl
, makeDesktopItem
, symlinkJoin
, wrapWine
, ... }:
let
  source = fetchurl {
    url = "https://ia600909.us.archive.org/6/items/kindle-for-pc-1-17-44170/kindle-for-pc-1-17-44170.exe";
    sha256 = "001j2r2024icfr8nk6z9pxzp0krlf30jv2a6qk3w0xhj7w2z1q0l";
  };

  python-win-installer = fetchurl {
    url = "https://www.python.org/ftp/python/3.9.6/python-3.9.6.exe";
    sha256 = "506f8d88063191e9c579a4d6b4274b16e941d004ce33f99ab34ef4c5be23e45b";
  };

  name = "kindle";

  bin = wrapWine {
    inherit name;

    firstrunScript = ''
      echo "installing Kindle for PC"
      wine ${source} /S

      # create the default content folder 
      mkdir -p "$WINE_NIX_PROFILES/${name}/Documents/My Kindle Content"

      # set the windows version reported by wine to 8.1, so we can install python 3
      winecfg /v win81

      # install python3 in our wine prefix
      echo "installing python"
      wine ${python-win-installer} /quiet

      # install cryptodome python module
      wine py -m pip install pycryptodome

      # reset windows version back to win7 to make the Kindle app happy
      winecfg /v win7   
    '';

    setupScript = ''
      # disable auto update
      APP_DIR="$WINE_NIX_PROFILES/${name}/AppData/Local/Amazon/Kindle"
      mkdir -p "$APP_DIR"
      rm -rf "$APP_DIR/updates"
      echo "no thanks" > "$APP_DIR/updates"
    '';

    executable = "$WINEPREFIX/drive_c/Program Files/Amazon/Kindle/Kindle.exe";
  };

  desktop = makeDesktopItem {
    name = "Kindle";
    desktopName = "Kindle";
    type = "Application";
    exec = "${bin}/bin/kindle";
    icon = fetchurl {
      url = "https://m.media-amazon.com/images/I/51NEb1QMCHL.png";
      sha256 = "0jk028paxfgxb3hwkn8igbzx7a7a3aqywz5v2spx920mqdc11bg1";
    };
  };
in symlinkJoin {
  name = "kindle";
  paths = [bin desktop];
}
