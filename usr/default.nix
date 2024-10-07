{ usr, ... }: {
  imports = [ ./pkg ./sh ./nixGL ./generic ./wm/picom/picom.nix ];
  nix.settings.trusted-users = [ "root" "@wheel" usr.username ];
}
