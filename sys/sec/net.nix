{ systemSettings, ... }: {
  # Pick only one of the below networking options.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.hostName = systemSettings.hostname;
  #services.opensnitch.enable = true;
  programs.mtr.enable = true;
}
