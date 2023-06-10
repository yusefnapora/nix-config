{ config, lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;

  theme-name = "nix-${config.colorScheme.slug}";
  colors = config.colorScheme.colors;

  clipboard_key_mods = if isDarwin then "CMD" else "SHIFT|CTRL";
in {
  config = {
    programs.wezterm = {
      enable = true;

      colorSchemes."${theme-name}" = with colors; {
        ansi = [
          "#${base00}" "#${base08}" "#${base0B}" "#${base0A}"
          "#${base0D}" "#${base0E}" "#${base0C}" "#${base05}"
        ];
        brights = [
          "#${base03}" "#${base08}" "#${base0B}" "#${base0A}"
          "#${base0D}" "#${base0E}" "#${base0C}" "#${base07}"
        ];
        background = "#${base00}";
        cursor_bg = "#${base05}";
        cursor_border = "#${base05}";
        cursor_fg = "#${base05}";
        foreground = "#${base05}";
        selection_bg = "#${base05}";
        selection_fg = "#${base00}";
      };

      extraConfig = ''
        local wezterm = require("wezterm")
        return {
          font = wezterm.font {
            family = 'FiraCode Nerd Font',
          },
          font_size = 14,
          check_for_updates = false,
          color_scheme = '${theme-name}',
          use_fancy_tab_bar = false,
          tab_max_width = 32,

          colors = {
            tab_bar = {
              background = '#${colors.base01}',
              active_tab = {
                bg_color = '#${colors.base0D}',
                fg_color = '#${colors.base00}',
              },
              inactive_tab = {
                bg_color = '#${colors.base00}',
                fg_color = '#${colors.base08}',
              },
              inactive_tab_hover = {
                bg_color = '#${colors.base00}',
                fg_color = '#${colors.base0D}',
              },
              new_tab = {
                bg_color = '#${colors.base02}',
                fg_color = '#${colors.base08}',
              },
              new_tab_hover = {
                bg_color = '#${colors.base00}',
                fg_color = '#${colors.base0D}',
              },
            },
          },

          mouse_bindings = {
            -- Ctrl-click will open the link under the mouse cursor
            {
              event = { Up = { streak = 1, button = 'Left' } },
              mods = 'CTRL',
              action = wezterm.action.OpenLinkAtMouseCursor,
            },
          },

          leader = { key="b", mods="CTRL" },
          -- disable_default_key_bindings = true,
          keys = {
              -- Send "CTRL-B" to the terminal when pressing CTRL-B, CTRL-B
              { key = "b", mods = "LEADER|CTRL",  action=wezterm.action.SendKey{ key="b", mods="CTRL" }},
              { key = "-", mods = "LEADER",       action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
              { key = "\\",mods = "LEADER",       action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
              { key = "z", mods = "LEADER",       action="TogglePaneZoomState" },
              { key = "c", mods = "LEADER",       action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
              { key = "h", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Left"}},
              { key = "j", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Down"}},
              { key = "k", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Up"}},
              { key = "l", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Right"}},
              { key = "H", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Left", 5}}},
              { key = "J", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Down", 5}}},
              { key = "K", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Up", 5}}},
              { key = "L", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Right", 5}}},
              { key = "1", mods = "LEADER",       action=wezterm.action{ActivateTab=0}},
              { key = "2", mods = "LEADER",       action=wezterm.action{ActivateTab=1}},
              { key = "3", mods = "LEADER",       action=wezterm.action{ActivateTab=2}},
              { key = "4", mods = "LEADER",       action=wezterm.action{ActivateTab=3}},
              { key = "5", mods = "LEADER",       action=wezterm.action{ActivateTab=4}},
              { key = "6", mods = "LEADER",       action=wezterm.action{ActivateTab=5}},
              { key = "7", mods = "LEADER",       action=wezterm.action{ActivateTab=6}},
              { key = "8", mods = "LEADER",       action=wezterm.action{ActivateTab=7}},
              { key = "9", mods = "LEADER",       action=wezterm.action{ActivateTab=8}},
              { key = "&", mods = "LEADER|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=true}}},
              { key = "x", mods = "LEADER",       action=wezterm.action{CloseCurrentPane={confirm=true}}},

              { key = "n", mods="SHIFT|CTRL",     action="ToggleFullScreen" },
              { key = "v",   mods="${clipboard_key_mods}",     action=wezterm.action.PasteFrom 'Clipboard'},
              { key = "c",   mods="${clipboard_key_mods}",     action=wezterm.action.CopyTo 'Clipboard'},
          },
        }
      '';
    };
  };
}
