{
  config,
  usr,
  globals,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    mkIf
    types
    optionals
    ;
  cfg = config.u.sh.nu;
in
{
  options.u.sh.nu.enable = mkOption {
    type = types.bool;
    default = usr.shell.pname == "nushell";
  };
  config = mkIf cfg.enable {
    home.shell.enableNushellIntegration = true;
    programs.nushell = {
      enable = true;
      # TODO: 
      plugins = [ ];
      settings = { };
    };
  };
}
