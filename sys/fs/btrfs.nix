{
  services = {
    btrfs = {
      autosScrub = {
        enable = true;
        interval = "quarterly";
        #TODO: filesystem
      };
    };
    btrbk = {
      instances = {
        #TODO: instances
      };
      #TODO: ssh
    };
  };
}
