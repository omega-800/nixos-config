{ lib, ... }:
let 
  inherit (lib) mkOption mkOverride types;
in 
{
  mkDisableOption =
    description:
    mkOption {
      inherit description;
      type = types.bool;
      default = true;
    };
  mkHighDefault = mkOverride 900;
  mkHigherDefault = mkOverride 800;
  mkHighererDefault = mkOverride 700;
  mkLowMid = mkOverride 600;
  mkMid = mkOverride 500;
  mkHighMid = mkOverride 400;
  mkHigherMid = mkOverride 300;
  mkHighererMid = mkOverride 200;
}
