{ lib, ... }:

{
  options = {
    mTlp.enable = lib.mkEnableOption "enables tlp";
    mPerformance.enable = lib.mkEnableOption "enables performance on battery";
  };
 
  config = lib.mkIf config.mTlp.enable {
    services.tlp = {
      enable = true;
      settings = {
        CPU_MIN_PERF_ON_BAT = 0;
        RUNTIME_PM_ON_BAT="auto";
        mkMerge [
          (lib.mkIf mPerformance {
            CPU_MAX_PERF_ON_BAT = 100;
            CPU_SCALING_GOVERNOR_ON_BAT = "performance";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "performance";
            CPU_BOOST_ON_BAT = 1;
            CPU_HWP_DYN_BOOST_ON_BAT = 1;
            START_CHARGE_THRESH_BAT0 = 65;
            STOP_CHARGE_THRESH_BAT0 = 80;
            PLATFORM_PROFILE_ON_BAT = "balanced";
            WIFI_PWR_ON_BAT="off";
            PCIE_ASPM_ON_BAT="default";
            WOL_DISABLE="Y";
          })
          (lib.mkIf !mPerformance {
            CPU_MAX_PERF_ON_BAT = 40;
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
            CPU_BOOST_ON_BAT = 0;
            CPU_HWP_DYN_BOOST_ON_BAT = 0;
            START_CHARGE_THRESH_BAT0 = 40;
            STOP_CHARGE_THRESH_BAT0 = 90;
            PLATFORM_PROFILE_ON_BAT = "low-power";
            WIFI_PWR_ON_BAT="on";
            WOL_DISABLE="N";
            PCIE_ASPM_ON_BAT="powersave";
          })
        ];

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 1;
        PLATFORM_PROFILE_ON_AC = "performance";
      };
    };
  };

}