{ lib, ... }: {
  mkHighDefault = val: lib.mkOverride 900 val;
  mkHigherDefault = val: lib.mkOverride 800 val;
  mkHighererDefault = val: lib.mkOverride 700 val;
  mkLowMid = val: lib.mkOverride 600 val;
  mkMid = val: lib.mkOverride 500 val;
  mkHighMid = val: lib.mkOverride 400 val;
  mkHigherMid = val: lib.mkOverride 300 val;
  mkHighererMid = val: lib.mkOverride 200 val;
}
