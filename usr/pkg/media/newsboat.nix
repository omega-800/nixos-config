{ lib, config, ... }: 
with lib;
let 
cfg = config.u.media;
in {
  config = mkIf cfg.enable {
    programs.newsboat = {
      enable = true;
      autoReload = true;
      urls = [
        "https://hnrss.org/newest"
          "https://hnrss.org/newest?q=git+OR+linux"
          "https://hnrss.org/best"
      ];
    };
  };
}
