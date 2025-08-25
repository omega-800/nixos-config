{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkBefore;
  inherit (builtins) elem;
  enabled = elem "lisp" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      vim-slime = {
        # enable = true;
      };
    };
  };
}
