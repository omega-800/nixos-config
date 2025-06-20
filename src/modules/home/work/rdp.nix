{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.u.work.rdp;
  inherit (lib) mkOption mkIf types;
in
{
  options.u.work.rdp.enable = mkOption {
    description = "enables rdp";
    type = types.bool;
    default = config.u.work.enable;
  };

  config = mkIf cfg.enable {
    /*
      services.remmina = {
        enable = true;
      };
    */
    home = {
      packages = with pkgs; [ freerdp ];
      shellAliases = {
        travel_connect = ''xfreerdp /v:172.16.100.24 /u:gs2 /p:$(pass work/travel) /sec:nla:off +clipboard /d:lan /drive:local,/home/omega/doc/work/travel -grab-keyboard /kbd:layout:0x00000807 /log-level:DEBUG''; # /microphone:sys:<> /sound:sys:<>
      };
    };
  };
}
