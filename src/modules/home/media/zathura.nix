{
  lib,
  config,
  pkgs,
  usr,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.media.zathura;
in
{
  options.u.media.zathura.enable = mkOption {
    type = types.bool;
    default = config.u.media.enable && (!usr.minimal);
  };

  config = mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      extraConfig = ''
        set selection-clipboard clipboard
        map gf exec firefox\ "$FILE"
        map ge exec xournalpp\ "$FILE"
        map gd exec zathura\ "$FILE"
      '';
    };
  };
}
