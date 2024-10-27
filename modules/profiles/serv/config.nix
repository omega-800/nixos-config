{ lib, usr, ... }:
{
  c = {
    sys = {
      hardened = true;
      paranoid = true;
    };
    usr = {
      style = lib.mkDefault false;
      minimal = true;
      extraBloat = false;
    };
  };
}
