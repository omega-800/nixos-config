{ pkgs, ... }: {
  home.mapackages = [ pkgs.nur.repos.wolfangaukang.mouseless ];
  home.file.".config/mouseless/config.yaml" = builtins.readFile ./config.yaml;
}
