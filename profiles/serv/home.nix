{ lib, usr, ... }:
with lib; {
  imports = [ ];
  u = {
    dev.enable = mkDefault true;
    file.enable = mkDefault true;
    net = {
      enable = mkDefault true;
      firefox.enable = false;
      vpn.enable = false;
    };
    user = {
      enable = mkDefault true;
      vim.enable = mkDefault true;
      nixvim.enable = mkDefault true;
      kitty.enable = false;
      alacritty.enable = false;
    };
    utils = {
      enable = mkDefault true;
      fzf.enable = mkDefault true;
      clipmenu.enable = false;
      rofi.enable = false;
      dunst.enable = false;
      # swhkd.enable = false;
      fetch.enable = mkDefault false;
      flameshot.enable = false;
    };
    posix.enable = mkDefault false;
    office.enable = false;
    work.enable = false;
    media.enable = false;
    social.enable = false;
  };
}
