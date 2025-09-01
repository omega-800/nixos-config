{
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-w520
    ./hardware-configuration.nix
  ];
  m = {
/*
    fs.disko = {
      enable = true;
      root = {
        device = "/dev/sda";
        type = "btrfs";
        impermanence.enable = false;
      };
    };
*/
    os.boot.mode = "uefi";
  };
  nixpkgs.config = {
    allowUnfreePredicate = _: false;
    allowUnfree = false;
    allowBroken = false;
  };
  system.stateVersion = "24.11";
}
