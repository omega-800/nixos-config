{
  usr,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types mkMerge;
  cfg = config.u.file.yazi;
in
{
  options.u.file.yazi = {
    enable = mkOption {
      description = "enables yazi";
      type = types.bool;
      default = config.u.file.enable && !usr.minimal;
    };
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      keymap = mkMerge [
        (import ./yazi-keymap.nix)
        {
          mgr.keymap = [
            {
              on = [ "<C-x>" ];
              run = ''shell -- xournalpp "$0"'';
            }
          ];
        }
      ];
      theme = {
        status = {
          sep_left = {
            open = "";
            close = "";
          };
          sep_right = {
            open = "";
            close = "";
          };
        };
      };
      settings = {
        log.enabled = false;
        mgr = {
          scrolloff = 8;
          show_hidden = true;
          show_symlink = true;
          sort_dir_first = true;
          sort_reverse = true;
          # switches while calculating
          # sort_by = "size";
        };
        preview = {
          tab_size = 2;
          wrap = "no";
          image_quality = 50;
        };
        opener = {
          edit = [
            {
              run = ''nvim "$@"'';
              block = true;
              for = "unix";
            }
          ];
          play = [
            {
              run = ''mpv "$@"'';
              orphan = true;
              for = "unix";
            }
          ];
          open = [
            {
              run = ''xdg-open "$@"'';
              desc = "Open";
            }
          ];
        };
      };
    };
  };
}
