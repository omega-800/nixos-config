{ lib, config, home, pkgs, ... }: {
  home.packages = with pkgs; [
    st
  ];
}
