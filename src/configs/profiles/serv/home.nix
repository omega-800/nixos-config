{
  globals,
  lib,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  imports = [ ];
  u = {
    dev = {
      enable = mkDefault false;
      git.enable = true;
    };
    file.enable = mkDefault false;
    net = {
      enable = mkDefault false;
      ssh.enable = mkDefault true;
    };
    user = {
      enable = mkDefault false;
      vim.enable = mkDefault true;
      dirs = with globals.envVars; {
        enable = mkDefault true;
        extraDirs = mkDefault [
          "${WORKSPACE_DIR}/services"
          "${XDG_DOCUMENTS_DIR}/services"
          "${XDG_DOCUMENTS_DIR}/logs"
        ];
      };
    };
    utils = {
      enable = mkDefault false;
      fzf.enable = mkDefault true;
      htop.enable = true;
      less.enable = true;
      ripgrep.enable = true;
    };
    posix.enable = mkDefault false;
    office.enable = false;
    work.enable = false;
    media.enable = false;
    social.enable = false;
  };
}
