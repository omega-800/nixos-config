{ usr, ... }: {
  c = {
    sys.paranoid = true;
    usr = {
      style = false;
      minimal = true;
    };
  };
}
