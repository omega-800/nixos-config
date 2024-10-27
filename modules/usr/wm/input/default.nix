{ pkgs, ... }:
{
  home.packages = [ pkgs.nur.repos.wolfangaukang.mouseless ];
  home.file.".config/mouseless/config.yaml".source = ./config.yaml;
}
