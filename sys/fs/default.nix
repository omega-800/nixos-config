{ config, lib, ... }:
with lib;
let cfg = config.m.dirs;
in {
  options.m.dirs = {
    enable = mkEnableOption "enables creation of directories";
  };
}
