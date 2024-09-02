{ pkgs, lib, ... }: {
  config.c = {
    sys = {
      hostname = "pixie";
      profile = "serv";
      system = "aarch64-linux";
      genericLinux = false;
      #paranoid = true;
      paranoid = lib.mkForce false;
    };
    usr = {
      shell = pkgs.zsh;
      extraBloat = false;
      theme = "gruvbox-dark-hard";
      style = false;
      minimal = true;
    };
  };
}
