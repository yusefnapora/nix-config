{ config, pkgs, lib, ...}:
let
  inherit (lib) lists strings;

  floating-apps = [
    "System Settings"
#    "Zoom"
#    "zoom.us"
  ];

  floating-rules = lists.forEach floating-apps (name: 
    "yabai -m rule --add app='${name}' manage=off"
    );
  floating-rules-str = strings.concatStringsSep "\n" floating-rules;

in
{
  services.yabai = {
    enable = true;

    config = {
      window_placement = "second_child";
      window_topmost = "on";
      window_shadow = "float";
      mouse_modifier = "ctrl";
    };

    extraConfig = floating-rules-str + "\n" 
    + ''
      yabai -m config layout bsp
    '';
  };

  services.skhd = let 
    hyper = "cmd + ctrl + alt";
    yabai = "${pkgs.yabai}/bin/yabai";
    wezterm = "/Applications/WezTerm.app/Contents/MacOS/wezterm";
  in {
    enable = true;

    skhdConfig = ''
      # sleep when "F13" key is pressed (mapped to scroll lock via karabiner)
      f13 : pmset displaysleepnow


      ${hyper} - return : ${wezterm} start
      ${hyper} - h : ${yabai} -m window --swap west  
      ${hyper} - j : ${yabai} -m window --swap south  
      ${hyper} - k : ${yabai} -m window --swap north 
      ${hyper} - l : ${yabai} -m window --swap east

      ${hyper} - space : ${yabai} -m window --toggle float
      ${hyper} - b : ${yabai} -m space --balance

      # increase size of the left-child (decrease size of right-child) of the containing node
      ${hyper} + shift - l : ${yabai} -m window --ratio rel:0.1

      # increase size of the right-child (decrease size of left-child) of the containing node
      ${hyper} + shift - h : ${yabai} -m window --ratio rel:-0.1
    '';
  };

  environment.systemPackages = [ pkgs.skhd ];

}
