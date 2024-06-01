{ config, lib, ... }: with lib; {
  config = mkIf config.u.file.enable {
    programs.lf = {
      enable = true;
      extraConfig = builtins.readFile ./lfrc;
    };
  };
}
