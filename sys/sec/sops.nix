{ pkgs, inputs, usr, ... }: {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${usr.homeDir}/.config/sops/age/keys.txt";
  };
}
