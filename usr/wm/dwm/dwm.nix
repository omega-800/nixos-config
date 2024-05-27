{ lib, config, ... }: {
  home.packages = with pkgs; [
    st
  ];
}
