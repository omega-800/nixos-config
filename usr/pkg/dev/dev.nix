{ lib, config, pkgs, home, ... }: 
with lib;
let cfg = config.u.dev;
in {
  options.u.dev = {
    enable = mkEnableOption "enables dev packages";
  };
 
  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "vscode"
      "ciscoPacketTracer8"
    ];
    home.packages = with pkgs; [
      # development
      qemu
      virt-manager
      gnumake
      vscode
      qmk
      jq
      git
      ncurses
      # ciscoPacketTracer8
      # put this in a nix-shell
      # nvm
      # npm
      # node
      # ansible-core
      # python3
    ];
  };
}
