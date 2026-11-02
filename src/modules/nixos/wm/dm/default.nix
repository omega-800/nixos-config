{lib,usr,...}:{
  imports = [
    ./lemurs.nix
    ./tuigreet.nix
  ];

  options.m.wm.dm = {
    enable = lib.mkOption {
      description = "enables dm";
      type = lib.types.bool;
      default = usr.wm != "none";
    };
  };
  # FIXME: 
  config.m.wm.dm.tuigreet.enable = lib.mkDefault true;
}
