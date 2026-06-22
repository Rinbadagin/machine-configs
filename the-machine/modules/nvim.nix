{ pkgs, lib, ... }: 
let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    # If you are not running an unstable channel of nixpkgs, select the corresponding branch of Nixvim.
    ref = "nixos-25.11";
  });
in
{
  imports = [
    # For Home Manager
    nixvim.homeModules.nixvim
  ]; 

  programs.nixvim = {
  plugins = {
      comment.enable = true;
      lualine.enable = true;
      web-devicons.enable = true;

      cmp = {
        enable = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };

      neo-tree = {
        enable = true;
        #autoLoad = true;
        #settings = {
        #  git.enable = true;
        #  sort_by = "case_sensitive";
        #  auto_reload_on_write = true;
        #  disable_netrw = true;
        #};
      };

      telescope = {
        enable = true;
        settings.defaults.mappings.i = {
          "<C-j>".__raw = "require('telescope.actions').move_selection_next";
          "<C-k>".__raw = "require('telescope.actions').move_selection_previous";
        };
      };

      treesitter = {
        enable = true;
        nixvimInjections = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
            settings.check.command = "clippy";
          };
          clangd.enable = true;
        };
      };
  };
    extraConfigLua = ''
      vim.cmd([[
          set autoindent expandtab tabstop=2 shiftwidth=2"
          set number relativenumber

          nnoremap <leader>ff <cmd>Telescope find_files<cr>
          nnoremap <leader>fg <cmd>Telescope live_grep<cr>
          nnoremap <leader>fb <cmd>Telescope buffers<cr>
          nnoremap <leader>fh <cmd>Telescope help_tags<cr>
      ]])
    '';
  };
  }
               
