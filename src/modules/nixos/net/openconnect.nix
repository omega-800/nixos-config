{
  lib,
  config,
  usr,
  sys,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    mkEnableOption
    mapAttrsToList
    optionalString
    mapAttrs'
    mkForce
    mkIf
    ;
  cfg = config.m.net.vpn.openconnect;
  ocfg = config.networking.openconnect;
in
{
  options.m.net.vpn.openconnect.enable = mkEnableOption "openconnect";

  config = mkIf cfg.enable {
    sops.secrets = {
      "vpn/school/password" = { };
      "vpn/school/fingerprint" = { };
      "vpn/school/cookie" = { };
    };
    environment.systemPackages = with pkgs; [
      openconnect
      inputs.openconnect-sso.packages.${sys.system}.openconnect-sso
    ];
    networking.openconnect.interfaces.school = {
      autoStart = false;
      gateway = "vpn2.ost.ch";
      protocol = "anyconnect";
      user = "georgiy.shevoroshkin@ost.ch";
      extraOptions = {
        cookie = ''"$(cat ${config.sops.secrets."vpn/school/cookie".path})"'';
        servercert = ''"$(cat ${config.sops.secrets."vpn/school/fingerprint".path})"'';
      };
    };
    systemd.services = mapAttrs' (name: _: {
      name = "openconnect-${name}";
      value =
        let
          icfg = ocfg.interfaces.${name};
        in
        {
          serviceConfig = {
            ExecStart = mkForce ''
              ${ocfg.package}/bin/openconnect \
                ${
                  (concatStringsSep " " (
                    mapAttrsToList (
                      name: value: if (value == true) then name else "--${name} ${value}"
                    ) icfg.extraOptions
                  ))
                } \
                ${optionalString (icfg.protocol != null) "--protocol ${icfg.protocol}"} \
                ${optionalString (icfg.user != null) "-u ${icfg.user}"} \
                ${icfg.gateway}
            '';
          };
        };
    }) ocfg.interfaces;

    networking = {
      networkmanager = {
        enable = true;
        plugins = with pkgs; [
          (networkmanager-openconnect.override { withGnome = true; })
        ];
        ensureProfiles = {
          profiles.school = {
            connection = {
              id = "school";
              type = "vpn";
            };
            vpn = {
              service-type = "org.freedesktop.NetworkManager.openconnect";

              cookie-flags = "1";

              autoconnect-flags = "0";
              # certsigns-flags = "4";
              # gwcert-flags = "4";
              # lasthost-flags = "4";
              # password-flags = "1";

              # enable_csd_trojan = "no";
              # gateway-flags = "4";
              # pem_passphrase_fsid = "no";
              # resolve-flags = "2";
              # stoken_source = "disabled";
              # prevent_invalid_cert = "no";

              gateway = "vpn.ost.ch";
              remote = "vpn.ost.ch";
              protocol = "anyconnect";
              useragent = "AnyConnect";
              username = "georgiy.shevoroshkin@ost.ch";
              authtype = "password";
            };
            # vpn-secrets = {
            #   gateway = "vpn.ost.ch";
            #   gwcert = "";
            #   cookie = "";
            #   resolve = "";
            # };
          };
        };
      };
    };
  };
}
