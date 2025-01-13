{
  config,
  ...
}:
# TODO: mkDisable
{
  services.gammastep = {
    enable = true;
    dawnTime = "6:00-7:30";
    duskTime = "19:00-20:30";
    latitude = "47.0";
    longitude = "8.0";
    provider = "manual";
    temperature = {
      day = 5500;
      night = 3500;
    };
  };
}
