{
  PATHS,
  lib,
  ...
}:
{
  imports = [ PATHS.M_HOME ];

  home.stateVersion = lib.mkDefault "25.11";
}
