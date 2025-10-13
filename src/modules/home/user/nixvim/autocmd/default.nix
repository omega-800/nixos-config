# https://github.com/AstroNvim/AstroNvim/blob/v4.7.7/lua/astronvim/plugins/_astrocore_autocmds.lua
{
  programs.nixvim = {
    autoGroups = {
      auto_quit.clear = true;
      autoview.clear = true;
      bufferline.clear = true;
      checktime.clear = true;
      create_dir.clear = true;
      editorconfig_filetype.clear = true;
      file_user_events.clear = true;
      highlighturl.clear = true;
      highlightyank.clear = true;
      large_buf_settings.clear = true;
      q_close_windows.clear = true;
      terminal_settings.clear = true;
      unlist_quickfix.clear = true;
      hihghlight_cursor_hold.clear = true;
      hihghlight_cursor_move.clear = true;
    };

    autoCmd =
      let 
        latex = "tex,bbl,bib,sty";
        typst = "typ";
        plantuml = "plantuml,puml,pu";
      in 
      # TODO: move to langs/
      (map
        (
          { pattern, command }:
          {
            inherit pattern;
            event = "FileType";
            command = "nnoremap <leader>mo ${builtins.replaceStrings [ " " ] [ "\\ " ] command}";
          }
        )
        [
          {
            pattern = latex + "," + typst;
            command = ":!zathura %:r.pdf > /dev/null 2>&1 &<cr><cr>";
          }
          {
            pattern = plantuml;
            command = ":!feh %:r.png > /dev/null 2>&1 &<cr><cr>";
          }
        ]
      )
      ++ (map
        (
          { pattern, command }:
          {
            inherit pattern;
            event = "FileType";
            command = "set makeprg=${builtins.replaceStrings [ " " ] [ "\\ " ] command}";
          }
        )
        [
          {
            pattern = latex;
            command = "pdflatex %:r.tex && bibtex %:r.aux && pdflatex %:r.tex && pdflatex %:r.tex && rm %:r.aux %:r.log %:r.blg %:r.bbl";
          }
          {
            pattern = typst;
            command = "typst compile %";
          }
          {
            pattern = "c";
            command = "make";
          }
          {
            pattern = "go";
            command = "go build";
          }
          {
            pattern = "rs";
            command = "cargo build";
          }
          {
            pattern = "hs";
            command = "ghc";
          }
          /*
            {
              pattern = plantuml;
              command = "plantuml %";
            }
          */
          {
            pattern = "js,ts";
            command = "npm run build";
          }
        ]
      )
      ++ (map
        (t: {
          # templates
          event = "BufNewFile";
          pattern = "*.${t}";
          command = "0r ${./templates/${t}.${t}}";
        })
        [
          "md"
          "html"
          "sh"
          "tex"
        ]
      )
      ++ [
        {
          # templates
          event = "BufNewFile";
          pattern = "README.md";
          command = "0r ${./templates/README.md}";
        }
        {
          # autoclose tags
          event = "FileType";
          pattern = "html,vue";
          command = "set omnifunc=htmlcomplete#CompleteTags";
        }
        # Open help in a vertical split
        {
          event = "FileType";
          pattern = "help";
          command = "wincmd L";
        }
        # Enable spellcheck for some filetypes
        /*
          {
            event = "FileType";
            pattern = [ "markdown" ];
            command = "setlocal spell spelllang=en,de";
          }
        */
        # auto_quit
        # https://github.com/AstroNvim/AstroNvim/blob/v4.7.7/lua/astronvim/plugins/_astrocore_autocmds.lua#L18-L46
        {
          desc = "Quit neovim if more than one window is open and only sidebar windows are list";
          event = "BufEnter";
          group = "auto_quit";

          callback.__raw = ''
            function()
              local wins = vim.api.nvim_tabpage_list_wins(0)
              -- Both neo-tree and aerial will auto-quit if there is only a single window left
              if #wins <= 1 then return end
              local sidebar_fts = { aerial = true, ["neo-tree"] = true }
              for _, winid in ipairs(wins) do
                if vim.api.nvim_win_is_valid(winid) then
                  local bufnr = vim.api.nvim_win_get_buf(winid)
                  local filetype = vim.bo[bufnr].filetype
                  -- If any visible windows are not sidebars, early return
                  if not sidebar_fts[filetype] then
                    return
                  -- If the visible window is a sidebar
                  else
                    -- only count filetypes once, so remove a found sidebar from the detection
                    sidebar_fts[filetype] = nil
                  end
                end
              end
              if #vim.api.nvim_list_tabpages() > 1 then
                vim.cmd.tabclose()
              else
                vim.cmd.qall()
              end
            end
          '';
        }

        # autoview
        # https://github.com/AstroNvim/AstroNvim/blob/v4.7.7/lua/astronvim/plugins/_astrocore_autocmds.lua#L49-L70
        {
          desc = "Save view with mkview for real files";
          event = [
            "BufWinLeave"
            "BufWritePost"
            "WinLeave"
          ];
          group = "autoview";

          callback.__raw = ''
            function(event)
              if vim.b[event.buf].view_activated then vim.cmd.mkview { mods = { emsg_silent = true } } end
            end
          '';
        }
        {
          desc = "Try to load file view if available and enable view saving for real files";
          event = "BufWinEnter";
          group = "autoview";

          callback.__raw = ''
            function(event)
              if not vim.b[event.buf].view_activated then
                local filetype = vim.bo[event.buf].filetype
                local buftype = vim.bo[event.buf].buftype
                local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
                if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
                  vim.b[event.buf].view_activated = true
                  vim.cmd.loadview { mods = { emsg_silent = true } }
                end
              end
            end
          '';
        }

        # checktime
        # https://github.com/AstroNvim/AstroNvim/blob/v4.7.7/lua/astronvim/plugins/_astrocore_autocmds.lua#L118-L122
        {
          desc = "Check if buffers changed on editor focus";
          event = [
            "FocusGained"
            "TermClose"
            "TermLeave"
          ];
          group = "checktime";
          command = "checktime";
        }

        # create_dir
        # https://github.com/AstroNvim/AstroNvim/blob/v4.7.7/lua/astronvim/plugins/_astrocore_autocmds.lua#L125-L132
        {
          desc = "Automatically create parent directories if they don't exist when saving a file";
          event = "BufWritePre";
          group = "create_dir";

          callback.__raw = ''
            function(event)
                     if event.match:match("^%w%w+://") then
                       return
                     end
                     local file = vim.loop.fs_realpath(event.match) or event.match
                     vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
                   end
          '';
        }

        # editorconfig_filetype
        # https://github.com/AstroNvim/AstroNvim/blob/v4.7.7/lua/astronvim/plugins/_astrocore_autocmds.lua#L135-L144
        {
          desc = "Configure editorconfig after filetype detection to override `ftplugin`s";
          event = "FileType";
          group = "editorconfig_filetype";

          callback.__raw = ''
            function(args)
              if vim.F.if_nil(vim.b.editorconfig, vim.g.editorconfig, true) then
                local editorconfig_avail, editorconfig = pcall(require, "editorconfig")
                if editorconfig_avail then editorconfig.config(args.buf) end
              end
            end
          '';
        }

        {
          desc = "Set up the default HighlightURL highlight group";
          event = [
            "VimEnter"
            "User"
          ];
          group = "highlighturl";

          callback.__raw = ''
            function(args)
              if args.event == "VimEnter" or args.match == "AstroColorScheme" then
                vim.api.nvim_set_hl(0, "HighlightURL", { default = true, underline = true })
              end
            end
          '';
        }

        # highlightyank
        # https://github.com/AstroNvim/AstroNvim/blob/v4.7.7/lua/astronvim/plugins/_astrocore_autocmds.lua#L206-L211
        {
          desc = "Highlight yanked text";
          event = "TextYankPost";
          group = "highlightyank";
          pattern = "*";

          callback.__raw = ''
            function()
              vim.highlight.on_yank()
            end
          '';
        }

        # q_close_windows
        # https://github.com/AstroNvim/AstroNvim/blob/v4.7.7/lua/astronvim/plugins/_astrocore_autocmds.lua#L242-L255
        {
          desc = "Make q close help, man, quickfix, dap floats";
          event = "BufWinEnter";
          group = "q_close_windows";

          callback.__raw = ''
            function(event)
              if vim.tbl_contains({ "help", "nofile", "quickfix" }, vim.bo[event.buf].buftype) then
                vim.keymap.set("n", "q", "<Cmd>close<CR>", {
                  desc = "Close window",
                  buffer = event.buf,
                  silent = true,
                  nowait = true,
                })
              end
            end
          '';
        }

        # terminal_settings
        # https://github.com/AstroNvim/AstroNvim/blob/v4.7.7/lua/astronvim/plugins/_astrocore_autocmds.lua#L258-L266
        {
          desc = "Disable line number/fold column/sign column for terminals";
          event = "TermOpen";
          group = "terminal_settings";

          callback.__raw = ''
            function()
              vim.opt_local.number = false
              vim.opt_local.relativenumber = false
              vim.opt_local.foldcolumn = "0"
              vim.opt_local.signcolumn = "no"
            end
          '';
        }

        # unlist_quickfix
        # https://github.com/AstroNvim/AstroNvim/blob/v4.7.7/lua/astronvim/plugins/_astrocore_autocmds.lua#L270-L275
        {
          desc = "Unlist quickfix buffers";
          event = "FileType";
          group = "unlist_quickfix";
          pattern = "qf";

          callback.__raw = ''
            function()
              vim.opt_local.buflisted = false
            end
          '';
        }
        /*
          {
            desc = "quickfix mappings";
            event = "FileType";
            pattern = "qf";
            callback.__raw = ''
              function()
                vim.keymap.set("n", "K", "<cmd>cprev<cr>zz<C-w>w", { buffer = event.buf, silent = true, noremap = true })
                vim.keymap.set("n", "J", "<cmd>cnext<cr>zz<C-w>w", { buffer = event.buf, silent = true, noremap = true })
              end
            '';
          }
        */
        {
          desc = "Close these type of File";
          event = [ "FileType" ];
          pattern = [
            "PlenaryTestPopup"
            "help"
            "lspinfo"
            "man"
            "notify"
            "qf"
            "query"
            "spectre_panel"
            "startuptime"
            "tsplayground"
            "neotest-output"
            "checkhealth"
            "neotest-summary"
            "neotest-output-panel"
          ];

          callback = {
            __raw = ''
              function(event)
                vim.bo[event.buf].buflisted = false
                vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
              end
            '';
          };
        }
        {
          event = [ "CursorHold" ];
          desc = "lsp show diagnostics on CursorHold";
          callback = {
            __raw = ''
              function()
                local hover_opts = {
                  focusable = false,
                  close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                  border = "rounded",
                  source = "always",
                }
                vim.diagnostic.open_float(nil, hover_opts)
              end
            '';
          };
        }

        {
          desc = "Save session";
          event = [ "BufWinLeave" ];
          pattern = [ "*.*" ];
          command = "mkview";
        }
        {
          desc = "Load session";
          event = [ "BufWinEnter" ];
          pattern = [ "*.*" ];
          command = "silent! loadview";
        }
      ];
  };
}
