{ lib, config, pkgs, ... }: 
with lib;
let 
  cfg = config.u.media;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ mpc-cli ];
    programs.ncmpcpp = {
      enable = true;
      bindings = [
        { key = "j"; command = "scroll_down"; }
        { key = "k"; command = "scroll_up"; }
        { key = "ctrl-u"; command = "page_up"; }
        { key = "ctrl-d"; command = "page_down"; }
        { key = "g"; command = "move_home"; }
        { key = "G"; command = "move_end"; }
        { key = "J"; command = [ "select_item" "scroll_down" ]; }
        { key = "K"; command = [ "select_item" "scroll_up" ]; }
        { key = "h"; command = "previous_column"; }
        { key = "l"; command = "next_column"; }
        { key = "."; command = "show_lyrics"; }
        { key = "n"; command = "next_found_item"; }
        { key = "N"; command = "previous_found_item"; }
      ];
    };
    services.mpd = {
      enable = true;
      startWhenNeeded = true;
    };
  };
}
