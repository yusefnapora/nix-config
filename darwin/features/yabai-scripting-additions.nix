{ lib, pkgs, ... }:
{
  services.yabai = {
    enableScriptingAddition = true;
    extraConfig = ''
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
      sudo yabai --load-sa
    '';
  }; 

  environment.etc = {
    "sudoers.d/10-yabai".text = ''
      %admin ALL=(root) NOPASSWD: ${pkgs.yabai}/bin/yabai --load-sa
    '';
  };

  services.skhd.skhdConfig = 
  let 
    hyper = "cmd + ctrl + alt";
    yabai = "${pkgs.yabai}/bin/yabai";
  in ''
    ${hyper} - left : ${yabai} -m window --space prev
    ${hyper} - right : ${yabai} -m window --space next
    ${hyper} - up : ${yabai} -m window --display recent
  '';
}
