{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.utils.htop;
in
{
  options.u.utils.htop.enable = mkOption {
    type = types.bool;
    default = config.u.utils.enable;
  };

  config = mkIf cfg.enable {
    programs.htop = {
      enable = true;
      package = pkgs.htop-vim;
      settings =
        {
          color_scheme = 6;
          cpu_count_from_one = 0;
          delay = 15;
          fields = with config.lib.htop.fields; [
            PID
            USER
            PRIORITY
            NICE
            M_SIZE
            M_RESIDENT
            M_SHARE
            STATE
            PERCENT_CPU
            PERCENT_MEM
            TIME
            COMM
          ];
          highlight_base_name = 1;
          highlight_megabytes = 1;
          highlight_threads = 1;
        }
        // (
          with config.lib.htop;
          leftMeters [
            (bar "AllCPUs2")
            (bar "Memory")
            (bar "Swap")
            (text "Zram")
          ]
        )
        // (
          with config.lib.htop;
          rightMeters [
            (text "Tasks")
            (text "LoadAverage")
            (text "Uptime")
            (text "Systemd")
          ]
        );
    };
  };
}
