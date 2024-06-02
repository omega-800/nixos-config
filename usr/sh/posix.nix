{ pkgs, ... }: {
  home.packages = with pkgs; [
    dash
    shellcheck
  ];
}
