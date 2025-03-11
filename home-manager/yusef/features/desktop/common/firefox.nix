{ config, lib, pkgs, inputs, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isLinux;
  addons = pkgs.nur.repos.rycee.firefox-addons;
in {
  config = mkIf isLinux {
    home.sessionVariables.BROWSER = "firefox";

    programs.firefox = {
      enable = true;
      profiles.yusef = {
        extensions.packages = with addons; [
          ublock-origin
          onepassword-password-manager
          # kagi-search
        ];
        settings = {
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "browser.disableResetPrompt" = true;
          "browser.download.panel.shown" = true;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.startup.homepage" = "https://kagi.com";
          "privacy.trackingprotection.enabled" = true;
          "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["ublock0_raymondhill_net-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","customizableui-special-spring1","urlbar-container","customizableui-special-spring2","downloads-button","fxa-toolbar-menu-button","_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["firefox-view-button","tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action","ublock0_raymondhill_net-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","unified-extensions-area"],"currentVersion":18,"newElementCount":2}'';
        };
      };
    };
    
    xdg = {
      mime.enable = true;
      mimeApps.enable = true;
      mimeApps.defaultApplications = {
        "text/html" = [ "firefox.desktop" ];
        "text/xml" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
      };
    };
  };
}
