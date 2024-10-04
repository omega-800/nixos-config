{ inputs, lib, pkgs, config, ... }:
let
  # disko
  disko = pkgs.writeShellScriptBin "disko" "${config.system.build.diskoScript}";
  disko-mount =
    pkgs.writeShellScriptBin "disko-mount" "${config.system.build.mountScript}";
  disko-format = pkgs.writeShellScriptBin "disko-format"
    "${config.system.build.formatScript}";
  cfg = config.m.fs.disko;
in
{
  imports = [ inputs.disko.nixosModules.disko ./pools ./root ];
  options.m.fs.disko.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enables disko";
  };
  config = {
    sops.secrets."hosts/default/disk" = { };
    disko.enableConfig = lib.mkDefault cfg.enable;

    # add disko commands to format and mount disks
    environment.systemPackages =
      if cfg.enable then [ disko disko-mount disko-format ] else [ ];
  };
}
