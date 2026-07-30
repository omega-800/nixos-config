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
  inherit (lib.omega.vim) keyG key;
in
{
  config = mkIf enabled {
    programs.nixvim = {
      keymaps = keyG "<leader>s" "strudel" [
        (key "n" " " "<Cmd>StrudelPause<CR>" "Pause")
        (key "n" "-" "<Cmd>StrudelPatterns<CR>" "Patterns")
        (key "n" "a" "<Cmd>StrudelAnalyze<CR>" "Analyze")
        (key "n" "b" "<Cmd>StrudelBanks<CR>" "Banks")
        (key "n" "c" "<Cmd>StrudelChords<CR>" "Chords")
        (key "n" "d" "<Cmd>StrudelDisconnect<CR>" "Disconnect")
        (key "n" "e" "<Cmd>StrudelEval<CR>" "Eval")
        (key "n" "h" "<Cmd>StrudelHush<CR>" "Hush")
        (key "n" "l" "<Cmd>StrudelLog<CR>" "Log")
        (key "n" "m" "<Cmd>StrudelSamples<CR>" "Samples")
        (key "n" "n" "<Cmd>StrudelConnect<CR>" "Connect")
        (key "n" "p" "<Cmd>StrudelPlay<CR>" "Play")
        (key "n" "r" "<Cmd>StrudelPianoroll<CR>" "Pianoroll")
        (key "n" "s" "<Cmd>StrudelStatus<CR>" "Status")
        (key "n" "t" "<Cmd>StrudelTheory<CR>" "Theory")
        (key "n" "u" "<Cmd>StrudelSounds<CR>" "Sounds")
        (key "n" "w" "<Cmd>StrudelScales<CR>" "Scales")
        (key "n" "x" "<Cmd>StrudelStop<CR>" "Stop")
      ];
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
