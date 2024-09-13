{
  boot.zfs = {
    enabled = true;
    forceImportAll = true;
    forceImportRoot = true;
  };
  services = {
    zfs = {
      autoScrub = {
        enable = true;
        interval = "quarterly";
      };
      #autoSnapshot.enable = true;
      trim = {
        enable = true;
        interval = "weekly";
      };
    };
    sanoid = {
      enable = true;
      interval = "daily";
      #TODO: configure sanoid
    };
  };
}
