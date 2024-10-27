{ inputs }: {
  mapChecks = builtins.mapAttrs
    (system: deployLib: deployLib.deployChecks inputs.self.deploy)
    inputs.deploy-rs-unstable.lib;
}
