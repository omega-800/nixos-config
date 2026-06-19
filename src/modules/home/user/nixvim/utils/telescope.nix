{
  lib,
  ...
}:
let
  inherit (lib.omega.vim) keyG key;
in
{
  programs.nixvim = {
    keymaps =
      (keyG "<leader>f" "find/file" [
        (key "n" "F" "<cmd>Telescope find_files hidden=true<cr>" "Find files Hidden Also")
        (key "n" "d" "<cmd>Telescope diagnostics theme=ivy<cr>" "Search Diagnostics")
        (key "n" "n" "<cmd>Telescope notify<cr>" "Notifications Search")
        (key "n" "k" "<cmd>Telescope keymaps theme=dropdown<cr>" "Search Keymaps")
        (key "n" "s" "<cmd>Telescope builtin<cr>" "Search Telescope")
        (key "n" "H" "<cmd>Telescope help_tags<cr>" "Search Help Tags")
        (key "n" "b" "<cmd>Telescope buffers<cr>" "Search Buffers")
        (key "n" "c" "<cmd>Telescope commands<cr>" "Search Commands")
        (key "n" "m" "<cmd>Telescope marks<cr>" "Search in Media Mode")
        (key "n" "o" "<cmd>Telescope vim_options<cr>" "Search Vim Options")
        (key "n" "q" "<cmd>Telescope quickfix<cr>" "Search Quickfix")
        (key "n" "l" "<cmd>Telescope loclist<cr>" "Search Location List")
        (key "n" "p" "<cmd>Telescope projects<cr>" "Search Projects")
        (key "n" "P" "<cmd>Telescope colorscheme<cr>" "Search ColorScheme with previews")
        (key "n" "u" "<cmd>Telescope undo<cr>" "Search undo")
        (key "n" "/" "<cmd>Telescope current_buffer_fuzzy_find<cr>" "Fuzzy Buffer Search")
        (key "n" "t" "<CMD>TodoTelescope<CR>" "Search TODO's")
      ])
      ++ [
        (key "n" "<leader>go" "<cmd>Telescope git_status<cr>" "Open changed file")
        (key "n" "<leader>gb" "<cmd>Telescope git_branches<cr>" "Checkout branch")
        (key "n" "<leader>gc" "<cmd>Telescope git_commits<cr>" "Checkout commit")
      ];
    plugins.telescope = {

      enable = true;
      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fo" = "oldfiles";
        "<leader>fg" = {
          action = "git_files";
          options.desc = "Telescope Git Files";
        };
      };
      extensions = {
        fzf-native.enable = true;
        undo.enable = true;
      };
      settings = {
        pickers = {
          colorscheme.enable_preview = true;
        };
        defaults.mappings = {
          n = {
            q = {
              __raw = "require('telescope.actions').close";
            };
            s = {
              __raw = "require('telescope.actions').select_horizontal";
            };
            v = {
              __raw = "require('telescope.actions').select_vertical";
            };
          };
        };
      };
    };
    # https://github.com/tjdevries/config.nvim/blob/master/lua/custom/telescope/multi-ripgrep.lua
    extraConfigLua = ''
      local conf = require("telescope.config").values
      local finders = require "telescope.finders"
      local make_entry = require "telescope.make_entry"
      local pickers = require "telescope.pickers"

      local flatten = vim.tbl_flatten

      -- i would like to be able to do telescope
      -- and have telescope do some filtering on files and some grepping

      vim.keymap.set("n", "<space>fr", function(opts)
          opts = opts or {}
          opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
          opts.shortcuts = opts.shortcuts
            or {
              ["l"] = "*.lua",
              ["v"] = "*.vim",
              ["n"] = "*.{vim,lua}",
              ["c"] = "*.c",
              ["r"] = "*.rs",
              ["g"] = "*.go",
            }
          opts.pattern = opts.pattern or "%s"

          local custom_grep = finders.new_async_job {
            command_generator = function(prompt)
              if not prompt or prompt == "" then
                return nil
              end

              local prompt_split = vim.split(prompt, "  ")

              local args = { "rg" }
              if prompt_split[1] then
                table.insert(args, "-e")
                table.insert(args, prompt_split[1])
              end

              if prompt_split[2] then
                table.insert(args, "-g")

                local pattern
                if opts.shortcuts[prompt_split[2]] then
                  pattern = opts.shortcuts[prompt_split[2]]
                else
                  pattern = prompt_split[2]
                end

                table.insert(args, string.format(opts.pattern, pattern))
              end

              return flatten {
                args,
                { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }
              }
            end,
            entry_maker = make_entry.gen_from_vimgrep(opts),
            cwd = opts.cwd
          }

          pickers
            .new(opts, {
              debounce = 100,
              prompt_title = "Live Grep (with shortcuts)",
              finder = custom_grep,
              previewer = conf.grep_previewer(opts),
              sorter = require("telescope.sorters").empty()
            })
            :find()
        end
      )
    '';
  };
}
