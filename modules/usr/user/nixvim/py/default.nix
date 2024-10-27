{
  usr,
  config,
  lib,
  ...
}:
{
  programs.nixvim = lib.mkIf (builtins.elem "python" config.u.user.nixvim.langSupport) {
    plugins = lib.mkMerge [
      ({
        molten = {
          enable = true;
          # package = pkgs.callPackage pkgs.vimUtils.buildVimPlugin {
          #   pname = "molten-nvim";
          #   version = "2023-10-21";
          #   src = pkgs.fetchFromGitHub {
          #     owner = "benlubas";
          #     repo = "molten-nvim";
          #     rev = "f9c28efc13f7a262e27669b984f3839ff5c50c32";
          #     sha256 = "1r8xf3jphgml0pax34p50d67rglnq5mazdlmma1jnfkm67acxaac";
          #   };
          #   meta.homepage = "https://github.com/benlubas/molten-nvim/";
          # };
          settings = {
            auto_open_output = true;
            copy_output = false;
            enter_output_behavior = "open_then_enter";
            output_crop_border = true;
            output_show_more = false;
            output_virt_lines = false;
            output_win_border = [
              ""
              "━"
              ""
              ""
            ];
            output_win_cover_gutter = true;
            output_win_hide_on_leave = true;
            output_win_style = false;
            save_path = {
              __raw = "vim.fn.stdpath('data')..'/molten'";
            };
            show_mimetype_debug = false;
            use_border_highlights = false;
            virt_lines_off_by1 = false;
            wrap_output = false;
          };
        };
      })
      (
        if usr.minimal then
          { }
        else
          {
            molten.settings.image_provider = "image.nvim";
            image = {
              enable = true;
              hijackFilePatterns = [
                "*.png"
                "*.jpg"
                "*.jpeg"
                "*.gif"
                "*.webp"
              ];
              windowOverlapClearFtIgnore = [
                "cmp_menu"
                "cmp_docs"
                ""
              ];
              backend =
                if usr.term == "kitty" then
                  "kitty"
                else if usr.term == "alacritty" then
                  "ueberzug"
                else
                  null;
              integrations = {
                markdown = {
                  enabled = true;
                  # downloadRemoteImage = true;
                  filetypes = [
                    "markdown"
                    "vimwiki"
                  ];
                };
              };
            };
          }
      )
    ];
  };
}
