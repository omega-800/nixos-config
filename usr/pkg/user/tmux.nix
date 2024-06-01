{ lib, config, pkgs, home, ... }: {
    home.packages = with pkgs; [ tmux ];
    programs.tmux = {
        enable = true;
        clock24 = true;
        historyLimit = 5000;
        extraConfig = builtins.readFile ./.tmux.conf;
    };
}
