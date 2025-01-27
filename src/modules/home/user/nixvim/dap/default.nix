{ lib, ... }:
let
  inherit (lib.omega.vim) keyG key keyS;
in
{
  programs.nixvim = {
    keymaps =
      [
        (keyS "n" "<F1>" ''<cmd>DapToggleBreakpoint<cr>'' "breakpoint toggle")
        (keyS "n" "<F2>" ''<cmd>DapContinue<cr>'' "continue")
        (keyS "n" "<F3>" ''<cmd>DapStepOver<cr>'' "over")
        (keyS "n" "<F4>" ''<cmd>DapStepInto<cr>'' "into")
        (keyS "n" "<F5>" ''<cmd>DapStepBack<cr>'' "back")
        (keyS "n" "<F6>" ''<cmd>DapStepOut<cr>'' "out")
        (keyS "n" "<F7>" ''<cmd>lua require("dap").pause()<cr>'' "pause")
        (keyS "n" "<F8>" ''<cmd>lua require("dap").restart()<cr>'' "restart")
        (keyS "n" "<F9>" "<cmd>DapTerminate<cr>" "exit")
      ]
      ++ (keyG "<leader>d" "diagnostics/debug" (
        [
          (keyS "n" "x" "<cmd>DapTerminate<cr>" "exit")
          (keyS "n" "r" ''<cmd>lua require("dap").run_to_cursor()<cr>'' "run to cursor")
          (keyS "n" "a" ''<cmd>lua require("dap").repl.open()<cr>'' "repl")
          (keyS "n" "b" ''<cmd>DapToggleBreakpoint<cr>'' "breakpoint toggle")
          (keyS "n" "c" ''<cmd>DapContinue<cr>'' "continue")
          (keyS "n" "B" ''<cmd>DapStepBack<cr>'' "back")
          (keyS "n" "n" ''<cmd>DapStepOver<cr>'' "over")
          (keyS "n" "i" ''<cmd>DapStepInto<cr>'' "into")
          (keyS "n" "o" ''<cmd>DapStepOut<cr>'' "out")
          (keyS "n" "l" ''<cmd>lua require("dap").run_last()<cr>'' "run last")
          (keyS "n" "p" ''<cmd>lua require("dap").pause()<cr>'' "pause")
          (keyS "n" "<Down>" ''<cmd>lua require("dap").down()<cr>'' "down")
          (keyS "n" "<Up>" ''<cmd>lua require("dap").up()<cr>'' "up")
          (keyS "n" "f" ''<cmd>lua require("dap").focus_frame()<cr>'' "focus frame")
          (keyS "n" "d" ''<cmd>lua require("dap").restart()<cr>'' "restart")
        ]
        ++ (keyG "u" "ui" [
          (key "n" "t" ''<cmd>lua require("dapui").toggle(1)<cr><cmd>lua require("dapui").toggle(2)<cr>''
            "toggle"
          )
          (key "n" "w" ''<cmd>lua require("dapui").eval(vim.fn.expand("<cword>"))<cr>'' "word eval")
          (key "n" "e" ''<cmd>lua require("dapui").eval(nil, { enter = true })<cr>'' "eval")
          (key [
            "n"
            "v"
          ] "h" ''<cmd>lua require("dap.ui.widgets").hover()<cr>'' "hover")
          (key [
            "n"
            "v"
          ] "p" ''<cmd>lua require("dap.ui.widgets").preview()<cr>'' "preview")
          (key "n" "s" ''<cmd>lua require("dap.ui.widgets").centered_float(widgets.scopes)<cr>''
            "scopes float"
          )
          (key "n" "f" ''<cmd>lua require("dap.ui.widgets").centered_float(widgets.frames)<cr>''
            "frames float"
          )
        ])
        ++ (keyG "v" "virtual-text" [
          (keyS "n" "t" ''<cmd>DapVirtualTextToggle<ct>'' "toggle")
          (keyS "n" "e" ''<cmd>DapVirtualTextEnable<ct>'' "enable")
          (keyS "n" "d" ''<cmd>DapVirtualTextDisable<ct>'' "disable")
          (keyS "n" "r" ''<cmd>DapVirtualTextForceRefresh<ct>'' "refresh")
        ])
      ));
    plugins.dap = {
      enable = true;
      extensions = {
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
      };
    };
    extraConfigLua =
      # lua
      ''
        -- TODO: this line should come before the lang-specific code
        local dap, dapui = require("dap"), require("dapui")

        -- DEBUG LISTENERS
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        dap.set_log_level('DEBUG')
      '';
  };
}
