{ bashScriptToNix, userSettings, ... }: 
let notifyScript = bashScriptToNix "malware_detected" ./malware_detected.sh;
in {
  services.clamav = {
    daemon = {
      enable = true;
      settings = {
        ExtendedDetectionInfo = "yes";
        FixStaleSocket = "yes";
        LocalSocket = "/var/run/clamav/clamd.ctl";
        LogFile = "/var/log/clamav/clamav.log";
        LogFileMaxSize = "5M";
        LogRotate = "yes";
        LogTime = "yes";
        MaxDirectoryRecursion = "15";
        MaxThreads = "20";
        OnAccessExcludeUname = "clamav";
        OnAccessExcludeUname = "root";
        OnAccessIncludePath = "/home";
        OnAccessMountPath = userSettings.homeDir;
        OnAccessPrevention = "yes";
        User = "root";
        VirusEvent = notifyScript;
      };
    };
    updater = {
      enable = true;
      interval = "hourly";
      frequency = 6;
    };
  };
}
