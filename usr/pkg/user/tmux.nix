{ lib, config, pkgs, home, ... }: with lib; {
  config = mkIf config.u.user.enable {
    home.packages = with pkgs; [ tmux ];
    programs.tmux = {
        enable = true;
        clock24 = true;
        historyLimit = 5000;
        extraConfig = builtins.readFile ./.tmux.conf;
      };
    };
}
