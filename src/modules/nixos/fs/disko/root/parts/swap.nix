{
  swap = {
    start = "-8GiB";
    end = "-0";
    type = "8200";
    content = {
      type = "swap";
      randomEncryption = true;
      # mountpoint = "/swap";
      priority = 100; # prefer to encrypt as long as we have space for it
      mountOptions = [
        "defaults"
        "nodev"
        "noexec"
        "nosuid"
        "nouser"
        "sw"
      ];
    };
  };
}
