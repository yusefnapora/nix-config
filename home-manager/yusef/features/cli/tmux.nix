{ lib, pkgs, config, ... }:
let
  oh-my-tmux = pkgs.fetchFromGitHub {
    owner = "gpakosz";
    repo = ".tmux";
    rev = "5641d3b3f5f9c353c58dfcba4c265df055a05b6b";
    sha256 = "sha256-BTeej1vzyYx068AnU8MjbQKS9veS2jOS+CaJazCtP6s=";

    # see https://github.com/NixOS/nixpkgs/issues/80109#issuecomment-1172953187  
    stripRoot = false;
  };
  tmux-conf = "${oh-my-tmux}/.tmux-${oh-my-tmux.rev}/.tmux.conf";

  inherit (config.colorScheme) colors;
in
{
  home.packages = [
    pkgs.tmux
  ];

  home.file.tmux-conf = {
    target = ".tmux.conf";
    source = tmux-conf;
  };

  home.file.tmux-conf-local = {
    target = ".tmux.conf.local";
    text = 
    ''
      # use Powerline symbols in status bar
      tmux_conf_theme_left_separator_main='\uE0B0'
      tmux_conf_theme_left_separator_sub='\uE0B1'
      tmux_conf_theme_right_separator_main='\uE0B2'
      tmux_conf_theme_right_separator_sub='\uE0B3'

      # customize status bar
      # removes uptime and battery info from default config
      tmux_conf_theme_status_left=" ❐ #S"
      tmux_conf_theme_status_right=" #{prefix}#{mouse}#{pairing}#{synchronized} | #{username}#{root} | #{hostname} "

      # show bar at top of window instead of bottom
      set -g status-position top

      # use 12 hour time format for big clock view
      tmux_conf_theme_clock_style="12"

      # copy mouse-mode selections to system clipboard
      tmux_conf_copy_to_os_clipboard=true

      # retain current path for new windows
      tmux_conf_new_window_retain_current_path=true      
      
      # just use C-b as prefix instead of C-b and C-a
      set -gu prefix2
      unbind C-a

      # start with mouse mode enabled
      set -g mouse on

      # use visual bell instead of audible beeps
      set -g visual-bell on

      # plugins
      set -g @plugin 'jabirali/tmux-tilish'
      # set -g @plugin 'ofirgall/tmux-window-name'

      # create a session called "main" if none exists
      # ref: https://gist.github.com/chakrit/5004006
      new-session -s main

      # use colors from current color color scheme
      # based on default ansi theme for "oh my tmux" config,
      # with colors from current "base 16" color scheme 
      tmux_conf_theme_colour_1="#${colors.base00}"
      tmux_conf_theme_colour_2="#${colors.base08}"
      tmux_conf_theme_colour_3="#${colors.base08}"
      tmux_conf_theme_colour_4="#${colors.base0D}"
      tmux_conf_theme_colour_5="#${colors.base0B}"
      tmux_conf_theme_colour_6="#${colors.base00}"
      tmux_conf_theme_colour_7="#${colors.base0F}"
      tmux_conf_theme_colour_8="#${colors.base00}"
      tmux_conf_theme_colour_9="#${colors.base0B}"
      tmux_conf_theme_colour_10="#${colors.base0D}"
      tmux_conf_theme_colour_11="#${colors.base0A}"
      tmux_conf_theme_colour_12="#${colors.base08}"
      tmux_conf_theme_colour_13="#${colors.base0F}"
      tmux_conf_theme_colour_14="#${colors.base00}"
      tmux_conf_theme_colour_15="#${colors.base00}"
      tmux_conf_theme_colour_16="#${colors.base01}"
      tmux_conf_theme_colour_17="#${colors.base0F}"

      # switch windows with <leader>-n and <leader>-p,
      # or <leader>-Left or <leader>-Right
      bind -r n next-window
      bind -r Right next-window
      bind -r p previous-window
      bind -r Left previous-window
    '';
  };

  #programs.fish.interactiveShellInit = 
  #''
  #  # auto-start tmux, if we're not already in a tmux session.
  #  # the destroy-unattached option prevents stale sessions from
  #  # piling up when you detach (ref: https://unix.stackexchange.com/a/222843)
  #
  #  if not set -q TMUX
  #    tmux new-session -t main \; set-option destroy-unattached
  #  end    
  #'';
}
