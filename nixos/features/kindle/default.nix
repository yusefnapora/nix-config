{ pkgs, lib, ... }:
let 
  # Script to extract the decryption key from Kindle for PC using the script
  # from the DeDRM calibre plugin (must be installed manually).
  # To use it with calibre, go to Preferences > Plugins > File Type > DeDRM
  # and hit "Configure plugin", then "Kindle for Mac/PC". On the dialog, import
  # the keyfile.
  # Note that the key is specific to each Kindle app install, so if you reinstall
  # the app, you'll need to extract the new key.
  kindle-key-script = (pkgs.writeScriptBin "kindle-key" ''
    SCRIPT_PATH="$HOME/.config/calibre/plugins/DeDRM/libraryfiles/kindlekey.py"
    if [ ! -f "$SCRIPT_PATH" ]; then
      echo "Calibre DeDRM plugin not found. Install and try again."
      exit 1
    fi

    if [ "$WINEPREFIX" = "" ]; then
      export WINEPREFIX="$HOME/.wine-nix/kindle"
    fi

    ${pkgs.wine}/bin/wine py -3 $SCRIPT_PATH ./kindlekey.k4i
  '');
in {
  environment.systemPackages = [
    kindle-key-script

    pkgs.local-pkgs.kindle_1_17

    pkgs.wine # needed for calibre DeDRM plugin to find the key
  ];

  # Kindle 1.17 needs a special certificate file to access the network.
  # see: https://askubuntu.com/a/1352999
  security.pki.certificateFiles = [
    ./kindle-verisign-cert.crt
  ];
}
