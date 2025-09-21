{ lib, ... }:
{
  config.c = {
    sys = {
      hardened = lib.mkDefault true;
      paranoid = lib.mkDefault true;
      stable = lib.mkDefault true;
    };
    usr = {
      style = lib.mkDefault false;
      minimal = lib.mkDefault true;
      extraBloat = lib.mkDefault false;
    };
  };
}
