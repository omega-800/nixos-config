{
  config,
  lib,
  usr,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.user.vim;
in
{
  options.u.user.vim.enable = mkOption {
    type = types.bool;
    default = config.u.user.enable && usr.minimal;
  };

  config = mkIf cfg.enable {
    programs.vim = {
      enable = true;
      #defaultEditor = true;
      settings = {
        background = "dark";
        mousehide = true;
      };
      extraConfig = builtins.readFile ./.vimrc;
    };
  };
}
