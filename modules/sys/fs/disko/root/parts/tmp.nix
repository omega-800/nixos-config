{
  config,
  lib,
  sys,
  ...
}:
{
  # disko.devices = lib.mkIf config.m.fs.disko.enable {
  #   nodev."/tmp" = {
  #     fsType = "tmpfs";
  #   };
  # };
  boot.tmp = {
    #TODO: make /run/secrets permanent
    # cleanOnBoot = true;
    # useTmpfs = true;
  };
}
