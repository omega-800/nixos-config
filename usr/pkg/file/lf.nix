{ config, lib, ... }: with lib; {
  config = mkIf config.u.file.enable {
    extraConfig = builtins.readFile ./lfrc;
  };
}
