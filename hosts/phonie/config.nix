{ pkgs, ... }: {
  config.c = {
    sys = {
      profile = "serv";
      system = "aarch64-linux";
      genericLinux = false;
      stable = false;
    };
    usr = {
      shell = pkgs.zsh;
      extraBloat = false;
      theme = "gruvbox-dark-hard";
      #theme = "atom-dark";
      termColors = {
        c1 = "36";
        c2 = "35";
      };
    };
  };
}
