{ inputs, lib, pkgs, config, ... }:
let cfg = config.m.fs.disko;
in {
  imports = [ inputs.disko.nixosModules.disko ./pools ./root ];
  options.m.fs.disko.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enables disko";
  };
  config = {
    disko.enableConfig = lib.mkDefault cfg.enable;

    # add disko commands to format and mount disks
    # environment.systemPackages =
    #   if cfg.enable then [ disko disko-mount disko-format ] else [ ];
  };
}
