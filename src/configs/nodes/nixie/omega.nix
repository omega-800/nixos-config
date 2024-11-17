{ pkgs, ... }:
{
  config.c = {
    net = {
      id = 52;
      pubkeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL9b/N++cCJpu4Bo4Lftg1FdmW33q59XdEdk2HBei/9e omega@nixie"
      ];
    };
    sys = {
      profile = "pers";
      system = "x86_64-linux";
      genericLinux = false;
      stable = false;
      hardened = false;
      flavors = [
        "developer"
        "master"
      ];
    };
    usr = {
      wm = "sway";
      shell = pkgs.zsh;
      term = "kitty";
      extraBloat = true;
      theme = "gruvbox-dark-hard";
      #theme = "atom-dark";
      termColors = {
        c1 = "36";
        c2 = "35";
      };
    };
  };
}
