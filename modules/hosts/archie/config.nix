{ pkgs, ... }: {
  config.c = {
    sys = {
      profile = "pers";
      system = "x86_64-linux";
      genericLinux = true;
      pubkeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBG4vyC8dYQEEv7JUeWmHqeKNBrB/GmV4sXED4dkhT2u omega@archie"
      ];
    };
    usr = {
      wm = "dwm";
      shell = pkgs.zsh;
      extraBloat = false;
      theme = "gruvbox-dark-hard";
      #theme = "catppuccin-mocha";
    };
  };
}
