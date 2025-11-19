{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "zig" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable {
        zls = {
          enable = true;
          cmd = ["zls"];
          filetypes = ["zig" "zir"];
        };
      };
      zig = {
        enable = true;
        settings = {
          fmt_autosave = 0;
        };
      };
    };
  };
}
