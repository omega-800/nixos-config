{
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-w520
  ];
  nixpkgs.config = {
    allowUnfreePredicate = _: false;
    allowUnfree = false;
    allowBroken = false;
  };
  system.stateVersion = "23.11";
}
