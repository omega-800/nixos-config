{
  imports = [
    ./lemurs.nix
    ./tuigreet.nix
  ];
  # FIXME: 
  config.m.wm.dm.tuigreet.enable = true;
}
