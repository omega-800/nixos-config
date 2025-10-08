{ pkgs, ... }:
{
  u.user = {
    nixvim = {
      enable = true;
      langSupport = [
        "js"
        "sh"
        "c"
        "css"
        "yaml"
        "html"
        "python"
        "erlang"
        "sql"
        "go"
        "java"
        "md"
        "nix"
        "gql"
        "docker"
        "lua"
        "rust"
        "hs"
      ];
    };
    vim.enable = false;
  };
  # TODO: programs.dconf
  home.packages = with pkgs; [
    qemu
    virt-manager
    dconf
  ];
}
