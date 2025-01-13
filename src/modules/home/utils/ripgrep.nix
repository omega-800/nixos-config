{ lib, config, ... }:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.utils.ripgrep;
in
{
  options.u.utils.ripgrep.enable = mkOption {
    type = types.bool;
    default = config.u.utils.enable;
  };

  config = mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--max-columns-preview"
        "--colors=line:style:bold"
      ];
    };
  };
}
