{ lib, config, pkgs, ... }: 
with lib;
let cfg = config.u.utils.fetch;
in {
  options.u.utils.fetch.enable = mkOption {
      type = types.bool;
      default = config.u.utils.enable;
  };
 
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      owofetch
      fastfetch
      onefetch
      bunnyfetch
      ghfetch
    ];
  };
}