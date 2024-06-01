{ config, ... }: {
  services.dunst = mkIf config.u.utils.enabled {
    enable = true;
    settings = {
      global = {
        follow = "keyboard";
      };
    };
  };
}
