{
  config,
  ...
}:
let
  mountOptions = [
    "defaults"
    "nodev"
    "noexec"
    "umask=0077"
    "ro"
  ];
in
if (config.m.os.boot.mode == "bios") then
  {
    boot = {
      #label = "boot";
      priority = 1;
      start = "0";
      size = "2M";
      end = "+2M";
      type = "EF02";
      # FIXME:
      # content = { inherit mountOptions; };
    };
  }
else if (config.m.os.boot.mode == "uefi") then
  {
    ESP = {
      label = "boot";
      name = "ESP";
      priority = 1;
      start = "0";
      size = "1G";
      end = "+1G";
      type = "EF00";
      content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = config.m.os.boot.efiPath;
        inherit mountOptions;
      };
    };
  }
# TODO: 
else
  { }
