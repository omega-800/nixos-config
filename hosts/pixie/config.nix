{ pkgs, lib, ... }: {
  config.c = {
    sys = {
      profile = "serv";
      system = "aarch64-linux";
      bootMode = "ext";
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
