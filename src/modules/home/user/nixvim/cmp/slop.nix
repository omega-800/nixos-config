{ pkgs, config, lib, ... }:
{
  programs.nixvim = lib.mkIf config.u.dev.slop.enable {
    plugins.opencode = {
      enable = true;
      settings = {};
    };
    extraConfigLua = ''
      -- local ocv_cmd = "bash -c 'opencode --port'"
      local ocv_cmd = "bash -c 'tmux split-window -h opencode --port'"

      vim.g.opencode_opts = {
        server = {
          start = function()
            require("opencode.terminal").open(ocv_cmd)
          end,
          toggle = function()
            require("opencode.terminal").toggle(ocv_cmd)
          end,
        },
      }

      vim.o.autoread = true -- Required for `vim.g.opencode_opts.events.reload`

      -- Recommended/example keymaps
      vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ") end, { desc = "Ask OpenCode…" })
      vim.keymap.set({ "n", "x" }, "<leader>os", function() require("opencode").select() end,       { desc = "Select OpenCode…" })

      vim.keymap.set({ "n", "x" }, "<leader>or",  function() return require("opencode").operator("@this ") end,        { desc = "Append range to OpenCode", expr = true })
      vim.keymap.set("n",          "<leader>op", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Append line to OpenCode", expr = true })

      vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll OpenCode up" })
      vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll OpenCode down" })
    '';
  };
}
