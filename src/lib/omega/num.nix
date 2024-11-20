{ lib, ... }:
let
  inherit (lib) toBaseDigits;
  inherit (builtins) elemAt length;
in
rec {
  mod = a: b: a - (b * (a / b));
  pow =
    a: b:
    if b == 1 then
      a
    else if b == 0 then
      1
    else
      (if (mod b 2) != 0 then a else 1) * pow (a * a) (b / 2);
  # a * pow a (b - 1);
  digit = a: b: elemAt (toBaseDigits 10 a) b;
  digits = a: length (toBaseDigits 10 a);
}
