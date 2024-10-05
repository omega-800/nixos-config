{ config, inputs, usr, ... }: {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile =
      let location = "${usr.homeDir}/.config/sops/age/keys.txt";
      in if config.m.fs.disko.root.impermanent then
        "/persist${location}"
      else
        location;
  };
}
