# Convert config.monitors into sway's format
{ lib, monitors }:
let 
  enabledMonitors = lib.filter (m: m.enabled) monitors;
  outputList = lib.forEach enabledMonitors (m: let 
    w = builtins.toString m.width;
    h = builtins.toString m.height;
    hz = builtins.toString m.refreshRate;
    scale = builtins.toString m.scale;
    in {
      name = m.name;
      value = {
        mode = "${w}x${h}@${hz}Hz";
        scale = scale;
      };
    });
in
builtins.listToAttrs outputList
