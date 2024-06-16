{ sys, ... }: {
  # Pick only one of the below networking options.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  networking = {
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    hostName = sys.hostname;
    extraHosts = ''
     127.0.0.1 local.sendy.inteco.ch
    '';
  };
  #services.opensnitch.enable = true;
  programs.mtr.enable = true;
}
