{
  lib,
  config,
  inputs,
  usr,
  PATHS,
  ...
}:
let
  keysDir = ".config/sops";
  keysLocation = "${usr.homeDir}/${keysDir}/age/keys.txt";
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = PATHS.SECRETS + /secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile =
      if config.m.fs.disko.root.impermanence.enable then "/nix/persist${keysLocation}" else keysLocation;
  };
  environment.persistence = lib.mkIf config.m.fs.disko.root.impermanence.enable {
    "/nix/persist".users."${usr.username}".directories = [
      {
        directory = keysDir;
        mode = "0700";
      }
    ];
  };
}
