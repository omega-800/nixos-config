{ inputs }:
let
  inherit (import ../utils { inherit inputs; })
    mkCfg
    mkUserArgs
    mkHomeModules
    mkPkgs
    mkOverlays
    getHomeMgrInput
    mapHostConfigs
    allUsers
    CONFIGS
    ;
  inherit (inputs.nixpkgs-unstable.lib) foldl' attrValues;
  userOutputName = cfg: user:
    if (user.usr.username == cfg.usr.username) then
      cfg.net.hostname
    else
      "${cfg.net.hostname}-${user.usr.username}";
  mkHome = cfg: user:
    let
      inherit (cfg.sys) system genericLinux;
      inherit (user) stable;
    in
    (getHomeMgrInput stable).lib.homeManagerConfiguration {
      pkgs = mkPkgs stable system genericLinux;
      extraSpecialArgs = mkUserArgs cfg user;
      modules = [
        { nixpkgs.overlays = mkOverlays stable system genericLinux; }
      ] ++ mkHomeModules cfg user;
    };
  mkHomes = hostname:
    let
      cfg = mkCfg hostname;
    in
    foldl' (acc: user: acc // { ${userOutputName cfg user} = mkHome cfg user; }) { } (allUsers cfg);
in
{
  mapHomes =
    let
      hosts = mapHostConfigs CONFIGS.homeConfigurations (h: h);
    in
    foldl' (acc: hostname: acc // (mkHomes hostname)) { } (attrValues hosts);
}
