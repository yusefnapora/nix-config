{ lib, pkgs, config, inputs, ...}:
let
  inherit (inputs) nixvim;

  vim-just = pkgs.vimUtils.buildVimPlugin {
    name = "vim-just";
    src = pkgs.fetchFromGitHub {
      owner = "NoahTheDuke";
      repo = "vim-just";
      rev = "adf500b84eb98ba56ad3f10672e1b2dc1de47b5f";
      sha256 = "sha256-YxqFZNtv7naC3faI1kPYI2pnzX8sm3akMBydZrYLHgM=";
    };
  };
in  
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    globals = {
      mapleader = ";";
      rust_recommended_style = false;
    };

    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      clipboard = "unnamedplus";

      # hide the native status line, since airline makes it redundant
      showmode = false;
      ruler = false;
      laststatus = 0;
    };

    keymaps = [
      # move between split panes with ctrl+ movement keys, without Ctrl+W prefix first
      { 
        options.desc = "focus pane down";
        key = "<C-J>";
        action = "<C-W><C-J>"; 
      }
      {
        options.desc = "focus pane left";
        key = "<C-H>"; 
        action = "<C-W><C-H>";
      }
      {
        options.desc = "focus pane up";
        key = "<C-K>";
        action = "<C-W><C-K>";
      }
      {
        options.desc = "focus pane right";
        key = "<C-L>"; 
        action = "<C-W><C-L>";
      }
      {
        options.desc = "toggle nvim-tree";
        key = "<leader>t"; 
        action = "<cmd>NvimTreeToggle<CR>";
      }
      {
        options.desc = "clear search highlighting";
        options.silent = true;
        mode = "n";
        key = "<C-C>";
        action = ":noh<CR>";
      }
    ];

    # color scheme config
    extraConfigVim = import ./theme.nix config.colorScheme;

    extraPlugins = [ 
      vim-just
      pkgs.vimPlugins.cheatsheet-nvim
      pkgs.vimPlugins.vim-airline-themes
    ];

    plugins = {
      airline = {
        enable = true;
        settings = {
          powerline_fonts = true;
          theme = "base16";
        };
      };

      barbar.enable = true;
      rust-tools = {
        enable = true;
        server = {
          cargo.features = "all";
        };
      };
      nix.enable = true;

      
      neogit = {
        enable = true;
        settings = { 
          kind = "auto";
        };
      };

      nvim-tree = {
        enable = true;
        openOnSetup = true;
        respectBufCwd = true;
        updateFocusedFile.enable = true;
      };

      comment.enable = true;


      cmp = {
        enable = true;
        
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];

          mapping = let
            if-visible = (action: ''
              function(fallback)
                if cmp.visible() then
                  ${action}
                else
                  fallback()
                end
              end
            '');

            m = (action: if-visible "cmp.mapping(${action}, {'i', 's', 'c'})");
            
            select-next = m "cmp.mapping.select_next_item()";
            select-prev = m "cmp.mapping.select_prev_item()";
            scroll-next = m "cmp.scroll_docs(4)";
            scroll-prev = m "cmp.scroll_docs(-4)";
          in {
            "<CR>" = "cmp.mapping.confirm({ select = false })";
            "<Tab>" = select-next;
            "<C-n>" = select-next;
            "<Down>" = select-next;
            "<C-p>" = select-prev;
            "<Up>" = select-prev;

            # scroll inside the popup view
            "<C-Up>" = scroll-prev;
            "<C-b>" = scroll-prev;
            "<C-Down>" = scroll-next;
            "<C-f>" = scroll-next;
          };
        };
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };

      lsp = {
        enable = true;

        servers = {
          jsonls.enable = true;
          rnix-lsp.enable = true;
        };
      };

      typescript-tools = {
        enable = true;
      };

      treesitter = {
        enable = false; # TODO: figure out a smaller set of grammars - "all" takes forever to download
        ensureInstalled = "all";
      };
    };

  };
}
