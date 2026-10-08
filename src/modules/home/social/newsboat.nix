{
  usr,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.social.newsboat;
in
{
  options.u.social.newsboat.enable = mkOption {
    type = types.bool;
    default = config.u.social.enable && usr.extraBloat;
  };

  config = mkIf cfg.enable {
    programs.newsboat = {
      enable = true;
      autoReload = true;
      urls = [
        { url = "https://hnrss.org/newest"; }
        { url = "https://hnrss.org/newest?q=git+OR+linux"; }
        { url = "https://hnrss.org/best"; }
        { url = "https://events.ccc.de/feed"; }
      ];
    };
  };
}
