{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) str nullOr listOf submodule enum addCheck int;
in
{
  options.c = {
    net = {
      networks = {
        type = listOf submodule {
          options =
            let
              ipType = str;
              dnsType = str;
              #ipType = addCheck str (x: builtins.match "^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)(\.(?!$)|$)){4}$");
            in
            {
              name = mkOption {
                type = nullOr str;
                default = "Home LAN";
                description = "Name of the network (not evaluated)";
              };
              type = mkOption {
                type = enum [ "vpn" "lan" ];
                default = "lan";
              };
              subnet = mkOption {
                type = addCheck int (x: x >= 1 && x <= 32);
                default = 24;
              };
              gatewayIp = mkOption {
                type = ipType;
                default = "10.0.0.1";
              };
              staticIp = mkOption {
                type = nullOr ipType;
                default = "10.0.0.47";
              };
              dnsIps = mkOption {
                type = listOf dnsType;
                    default = [ "10.0.0.45" "8.8.8.8"];
              };
            };
        };
      };
      interfaces = {
        type = listOf submodule {
          options =
            let
              ipType = str;
              dnsType = str;
              #ipType = addCheck str (x: builtins.match "^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)(\.(?!$)|$)){4}$");
            in
            {
              name = mkOption {
                type = str;
                default = "wlp108s0";
                description = "Name of the interface";
              };
              type = mkOption {
                type = enum [ "wifi" "eth" "wg" ];
                default = "eth";
              };
              subnet = mkOption {
                type = addCheck int (x: x >= 1 && x <= 32);
                default = 24;
              };
              gatewayIp = mkOption {
                type = ipType;
                default = "10.0.0.1";
              };
              staticIp = mkOption {
                type = nullOr ipType;
                default = "10.0.0.47";
              };
              dnsIps = mkOption {
                type = listOf dnsType;
                default = [ "10.0.0.45" ];
              };
            };
        };
      };
    };
  };
}
