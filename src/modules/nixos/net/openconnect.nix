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
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.omega.attrs) flatMapToAttrs;
  cfg = config.m.net.vpn.openconnect;
in
{
  options.m.net.vpn.openconnect.enable = mkEnableOption "openconnect";

  config = mkIf cfg.enable {
    sops.secrets."school/vpn" = { };

    /*
      programs =
        flatMapToAttrs
          (sh: {
            "${sh}".shellAliases = {
              "vpn-school-start" = "openconnect-sso --server vpn.ost.ch --user georgiy.shevoroshkin@ost.ch";
            };
          })
          [
            "zsh"
            "bash"
            "fish"
          ];
    */
    environment.systemPackages = with pkgs; [
      openconnect
      /*
        (inputs.openconnect-sso.packages.${sys.system}.default.overrideAttrs (
          _: _: { dontCheckRuntimeDeps = true; }
        ))
      */
    ];

    networking = {
      networkmanager = {
        enable = true;
        plugins = with pkgs; [
          networkmanager-openconnect

          networkmanager-openvpn
          networkmanager-vpnc
        ];
        ensureProfiles = {
          secrets.entries = [
            {
              file = config.sops.secrets."school/vpn".path;
              matchId = "school";
              matchType = "vpn";
              matchSetting = "vpn-secrets";
              key = "password";
            }
          ];
          profiles.school = {
            connection = {
              id = "school";
              type = "vpn";
            };
            vpn = {
              service-type = "org.freedesktop.NetworkManager.openconnect";

              autoconnect-flags = "0";
              certsigns-flags = "4";
              cookie-flags = "0";
              # enable_csd_trojan = "no";
              # gateway-flags = "4";
              gwcert-flags = "4";
              lasthost-flags = "4";
              password-flags = "1";
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
            vpn-secrets = {
              gateway = "vpn.ost.ch";
              gwcert = "";
              cookie = "";
              resolve = "";
            };
          };
        };
      };
      /*
        openconnect = {
          # package = pkgs.openconnect-sso;
          interfaces = {
            school = {
              # FIXME: clean up this mess
              passwordFile = config.sops.secrets."school/vpn".path;
              gateway = "vpn.ost.ch";
              autoStart = false;
              user = usr.devEmail;
              protocol = "anyconnect";
            };
          };
        };
      */
    };
  };
}
