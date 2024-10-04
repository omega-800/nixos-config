{ sys, ... }: {
  environment.memoryAllocator.provider = if (sys.paranoid && !sys.stable) then
    "graphene-hardened"
  else if sys.paranoid then
    "scudo"
  else
    "libc";
  environment.variables.SCUDO_OPTIONS = "ZeroContents=1";
  security.forcePageTableIsolation = sys.paranoid;
  security.virtualisation.flushL1DataCache =
    if (sys.paranoid) then "always" else null;
}
