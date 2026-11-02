{
  usr,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.social.rss;
in
{
  options.u.social.rss.enable = mkOption {
    type = types.bool;
    default = config.u.social.enable && usr.extraBloat;
  };

  config = mkIf cfg.enable {
    programs.nom = {
      enable = true;
      settings = {
        autoread = true;
        feeds = [
          { url = "https://hnrss.org/newest"; }
          { url = "https://hnrss.org/newest?q=git+OR+linux"; }
          { url = "https://hnrss.org/best"; }
          { url = "https://events.ccc.de/feed"; }
        ];
      };
    };
  };
}
