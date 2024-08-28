{ lib, usr, ... }: {
  c = {
    sys.paranoid = true;
    usr = {
      style = lib.mkDefault false;
      minimal = true;
    };
  };
}
