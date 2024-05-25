{ lib, ... }: {
  networking.timeServers = options.networking.timeServers.default ++ [ 
    "0.ch.pool.ntp.org" 
    "1.ch.pool.ntp.org" 
    "2.ch.pool.ntp.org" 
    "3.ch.pool.ntp.org" 
  ];
  services.timesyncd.enable = true;
}
