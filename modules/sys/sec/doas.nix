{ usr, pkgs, ... }: {
  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [{
        users = [ "${usr.username}" ];
        keepEnv = true;
        persist = true;
      }];
    };
  };

  environment.systemPackages =
    [ (pkgs.writeScriptBin "sudo" ''exec doas "$@"'') ];
}
