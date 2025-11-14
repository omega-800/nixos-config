{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "zig" config.u.user.nixvim.langSupport;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins.zig = {
      enable = true;
      settings = {
        fmt_autosave = 0;
      };
    };
  };
}
