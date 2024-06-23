{ usr, lib, config, ... }: 
with lib;
let 
cfg = config.u.media;
in {
  config = mkIf (cfg.enable && usr.extraBloat) {
    programs.newsboat = {
      enable = true;
      autoReload = true;
      urls = [
        { url = "https://hnrss.org/newest"; }
        { url = "https://hnrss.org/newest?q=git+OR+linux"; }
        { url = "https://hnrss.org/best"; }
      ];
    };
  };
}
