
{
  usr,
  lib,
  config,
  pkgs,
  globals,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    mkMerge
    optionals
    ;
  cfg = config.u.dev.github;
in
{
  options.u.dev.github.enable = mkOption {
    type = types.bool;
    default = config.u.dev.git.enable;
  };

  config = mkIf cfg.enable {
    programs.gh= {
      enable = true; 
      gitCredentialHelper.enable = true;
      package = pkgs.gitAndTools.gh;
      hosts = {
        # TODO: 
        "github.com" = {
          user = "omega-800";
        };
      };
      settings = {
        inherit (usr) editor;
        git_protocol = "https";
        prompt = "enabled";
        # TODO: 
        aliases = {
          frk = "repo fork --clone";
        };
      };
    };
  };
}
