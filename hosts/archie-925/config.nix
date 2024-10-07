{ pkgs, ... }: {
  config.c = {
    sys = {
      profile = "work";
      system = "x86_64-linux";
      genericLinux = true;
      pubkeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF28oxG+EVTVwLKw3f+9+qnrY08wbJjnLqyBsOqKNt3O omega@archie-925"
      ];
    };
    usr = {
      term = "kitty";
      devName = "gs2";
      devEmail = "georgiy.shevoroshkin@inteco.ch";
      wm = "dwm";
      shell = pkgs.zsh;
      extraBloat = true;
      theme = "catppuccin-mocha";
      termColors = {
        c1 = "35";
        c2 = "91";
      };
    };
  };
}
