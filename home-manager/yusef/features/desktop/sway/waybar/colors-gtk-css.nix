{ config, ... }:
let
  inherit (config.colorScheme) colors;
in ''
  @define-color base00 #${colors.base00};
  @define-color base01 #${colors.base01};
  @define-color base02 #${colors.base02};
  @define-color base03 #${colors.base03};
  @define-color base04 #${colors.base04};
  @define-color base05 #${colors.base05};
  @define-color base06 #${colors.base06};
  @define-color base07 #${colors.base07};
  @define-color base08 #${colors.base08};
  @define-color base09 #${colors.base09};
  @define-color base0A #${colors.base0A};
  @define-color base0B #${colors.base0B};
  @define-color base0C #${colors.base0C};
  @define-color base0D #${colors.base0D};
  @define-color base0E #${colors.base0E};
  @define-color base0F #${colors.base0F};
''
