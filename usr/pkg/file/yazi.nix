{ usr, lib, config, ... }:
with lib;
let cfg = config.u.file.yazi;
in {
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
      # keymap = {
      #   input.keymap = [
      #     {
      #       exec = "close";
      #       on = [ "<C-q>" ];
      #     }
      #     {
      #       exec = "close --submit";
      #       on = [ "<Enter>" ];
      #     }
      #     {
      #       exec = "escape";
      #       on = [ "<Esc>" ];
      #     }
      #     {
      #       exec = "backspace";
      #       on = [ "<Backspace>" ];
      #     }
      #   ];
      #   manager.keymap = [
      #     {
      #       exec = "escape";
      #       on = [ "<Esc>" ];
      #     }
      #     {
      #       exec = "quit";
      #       on = [ "q" ];
      #     }
      #     {
      #       exec = "close";
      #       on = [ "<C-q>" ];
      #     }
      #   ];
      # };
      theme = {
        status = {
          separator_open = "";
          separator_close = "";
        };
      };
      settings = {
        log.enabled = false;
        manager = {
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
          edit = [{
            run = ''nvim "$@"'';
            block = true;
            for = "unix";
          }];
          play = [{
            run = ''mpv "$@"'';
            orphan = true;
            for = "unix";
          }];
          open = [{
            run = ''xdg-open "$@"'';
            desc = "Open";
          }];
        };
      };
    };
  };
}
