{ config, lib, ... }: with lib; {
  services.dunst = mkIf config.u.utils.enable {
    enable = true;
    settings = {
      global = {
        follow = "keyboard";
      };
    };
  };
}
