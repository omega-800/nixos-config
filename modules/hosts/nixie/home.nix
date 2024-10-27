{ lib, options, ... }:
{
  u = {
    social.enable = true;
    user.nixvim = {
      enable = true;
      langSupport = [
        "md"
        "sh"
        "nix"
        "rust"
      ];
    };
  };
  programs.nixvim.plugins = {
    # oil = {enable = lib.mkForce false;};
    # bufferline = {enable = lib.mkForce false;};
    # startup = {enable = lib.mkForce false;};
    # lualine = {enable = lib.mkForce false;};
    # typescript-tools = {enable = lib.mkForce false;};
    # none-ls = {enable = lib.mkForce false;};
    # treesitter = {enable = lib.mkForce false;};
    # treesitter-context = {enable = lib.mkForce false;};
    # treesitter-textobjects = {enable = lib.mkForce false;};
    # web-devicons = {enable = lib.mkForce false;};
    # rustaceanvim = {enable = lib.mkForce false;};
    # dap = {enable = lib.mkForce false;};
    # cmp = {enable = lib.mkForce false;};
    # cmp-buffer = {enable = lib.mkForce false;};
    # cmp-cmdline = {enable = lib.mkForce false;};
    # cmp-emoji = {enable = lib.mkForce false;};
    # cmp-nvim-lsp = {enable = lib.mkForce false;};
    # cmp-path = {enable = lib.mkForce false;};
    # comment = {enable = lib.mkForce false;};
    # fidget = {enable = lib.mkForce false;};
    # floaterm = {enable = lib.mkForce false;};
    # hardtime = {enable = lib.mkForce false;};
    # harpoon = {enable = lib.mkForce false;};
    # illuminate = {enable = lib.mkForce false;};
    # telescope = {enable = lib.mkForce false;};
    # tmux-navigator = {enable = lib.mkForce false;};
    # undotree = {enable = lib.mkForce false;};
    # which-key = {enable = lib.mkForce false;};
    # nvim-autopairs = {enable = lib.mkForce false;};
    # nvim-colorizer = {enable = lib.mkForce false;};
    # rainbow-delimiters = {enable = lib.mkForce false;};
    # todo-comments = {enable = lib.mkForce false;};
    # wilder = {enable = lib.mkForce false;};
    # git-worktree = {enable = lib.mkForce false;};
    # gitlinker = {enable = lib.mkForce false;};
    # gitsigns = {enable = lib.mkForce false;};
    # lazygit = {enable = lib.mkForce false;};
    # trouble = {enable = lib.mkForce false;};
    # lsp = {enable = lib.mkForce false;};
    # lsp-format = {enable = lib.mkForce false;};
    # lsp-lines = {enable = lib.mkForce false;};
  };
  # programs.nixvim.plugins = lib.listToAttrs (lib.attrNames (lib.concatMap (v: lib.attrNames v.plugins) options.programs.nixvim.definitions)) (name: {inherit name; value = { enable = lib.mkForce false;};});
}
