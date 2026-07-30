{
  usr,
  sys,
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) types mkIf mkOption;
  cfg = config.u.dev.slop;
in
{
  options.u.dev.slop.enable = mkOption {
    type = types.bool;
    default = # config.u.dev.enable && usr.extraBloat
      false;
  };

  config = mkIf cfg.enable {
    services.ollama.enable = true;
    programs.opencode = {
      enable = true;
      # bruh this is pretty useless
      package = inputs.opencode-vim.packages.${sys.system}.opencode;
      web.enable = false;
      enableMcpIntegration = true;
      settings = {
        autoshare = false;
        autoupdate = false;
      };
      tui.keybinds = {
        "app_exit" = "ctrl+c,<leader>q";
        "messages_half_page_up" = "ctrl+u";
        "messages_half_page_down" = "ctrl+d";
      };
    };
    home.packages = with pkgs; [
      ollama
    ];
  };
}
