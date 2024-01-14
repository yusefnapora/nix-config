{ config, pkgs, ... }:
{
  # start electron apps in native wayland mode

  programs.fish.shellAliases = {
    # vscode as of 1.85 doesn't work with wayland anymore, but the insiders build does,
    # so we only apply the hacks to code-insiders.
    # TODO: go back to non-insiders build when it works again
    code = "NIXOS_OZONE_WL=1 code-insiders";
    obsidian = "OBSIDIAN_USE_WAYLAND=1 obsidian -enable-features=UseOzonePlatform -ozone-platform=wayland";
    chromium = "chromium --ozone-platform=wayland";

    # leave 1password in Xwayland mode, since the clipboard is broken in wayland:
    # https://1password.community/discussion/121681/copy-passwords-under-pure-wayland
    # "1password" = "1password -enable-features=UseOzonePlatform -ozone-platform=wayland";
  };

  # apply wayland mode hacks to desktop entries for electron apps
  xdg.desktopEntries = {
    code = {
      name = "Visual Studio Code";
      terminal = false;
      icon = "${config.programs.vscode.package}/lib/vscode/resources/app/resources/linux/code.png";
      exec = "env NIXOS_OZONE_WL=1 code-insiders";
    };
    obsidian = {
      name = "Obsidian";
      terminal = false;
      icon = "${pkgs.obsidian}/share/icons/hicolor/256x256/apps/obsidian.png";        
      exec = "env OBSIDIAN_USE_WAYLAND=1 obsidian -enable-features=UseOzonePlatform -ozone-platform=wayland";
    };

    chromium-browser = {
      name = "Chromium";
      terminal = false;
      icon = "${pkgs.chromium}/share/icons/hicolor/256x256/apps/chromium.png";
      exec = "chromium --ozone-platform=wayland";
    };
    
    # use xwayland until clipboard bug is fixed: 
    # https://1password.community/discussion/121681/copy-passwords-under-pure-wayland 
    # "1password" = { 
    #   name = "1Password";
    #   terminal = false;
    #   icon = "${pkgs._1password-gui}/share/1password/resources/icons/hicolor/256x256/apps/1password.png";
    #   exec = "1password -enable-features=UseOzonePlatform -ozone-platform=wayland";
    # };   
  };

}
