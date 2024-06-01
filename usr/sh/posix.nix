{ ... }: {
  home.packages = with pkgs; [
    dash
    shellcheck
  ];
}
