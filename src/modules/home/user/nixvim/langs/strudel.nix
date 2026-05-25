{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "strudel" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
  nvim-strudel = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-strudel";
    version = "0.1.0";
    src = inputs.nvim-strudel;
  };
  strudel-server = inputs.nvim-strudel.packages.${pkgs.system}.server;
in
{
  config = mkIf enabled {
    programs.nixvim = {
      extraPlugins = [ nvim-strudel ];
      extraPackages = [
        strudel-server
        pkgs.supercollider
        pkgs.supercolliderPlugins.sc3-plugins
      ];
      extraConfigLua = ''
        require('strudel').setup({
          server = {
            cmd = { "${strudel-server}/bin/strudel-server" },
          },
          log = { enabled = true },
          lsp = { enabled = true },
          audio = {
            output = 'osc',
            osc_host = '127.0.0.1',
            osc_port = 57120,
            auto_superdirt = true,
          },
        })
      '';
    };
  };
}
