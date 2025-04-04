{
  programs.nixvim = {
    plugins.lualine = {
      enable = true;
      settings = {
        globalstatus = true;
        extensions = [ "neo-tree" ];
        disabledFiletypes = {
          statusline = [
            "startup"
            "alpha"
          ];
        };
        #theme = "catppuccin";
        sections = {
          lualine_a = [ "mode" ];
          # FIXME: refactoring due to deprecation
          # lualine_b = [{
          #   name = "branch";
          #   icon = "";
          # }];
          # lualine_c = [
          #   {
          #     name = "diagnostics";
          #     extraConfig = {
          #       sources = [ "nvim_lsp" ];
          #       symbols = {
          #         error = " ";
          #         warn = " ";
          #         info = " ";
          #         hint = "󰝶 ";
          #       };
          #     };
          #   }
          #   {
          #     name = "filetype";
          #     extraConfig = {
          #       icon_only = true;
          #       separator = "";
          #       padding = {
          #         left = 1;
          #         right = 0;
          #       };
          #     };
          #   }
          #   {
          #     name = "filename";
          #     extraConfig = { path = 1; };
          #   }
          # ];
          # lualine_x = [{
          #   name = "diff";
          #   extraConfig = {
          #     symbols = {
          #       added = " ";
          #       modified = " ";
          #       removed = " ";
          #     };
          #     source = {
          #       __raw = ''
          #         function()
          #           local gitsings = vim.b.gitsigns_status_dict
          #           if gitsigns then
          #             return {
          #               added = gitigns.added,
          #               modified = gitigns.changed,
          #               removed = gitigns.removed
          #             }
          #           end
          #         end
          #       '';
          #     };
          #   };
          # }];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
        };
      };
    };
  };
}
