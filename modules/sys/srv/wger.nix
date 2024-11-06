# Auto-generated using compose2nix v0.3.2-pre.
{ config, pkgs, lib, ... }:
let
  cfg = config.m.srv.wger;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.m.srv.wger.enable = mkEnableOption "Enables wger";
  config = mkIf cfg.enable {
    sops.secrets = {
      "wger/rootpw" = {
        mode = "0440";
        owner = config.users.users.wger.name;
      };
      "wger/db" = { };
    };
    # Runtime
    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        # Required for container networking to be able to use names.
        dns_enabled = true;
      };
    };

    # Enable container name DNS for non-default Podman networks.
    # https://github.com/NixOS/nixpkgs/issues/226365
    networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];

    virtualisation.oci-containers.backend = "podman";

    # Containers
    virtualisation.oci-containers.containers."wger-cache" = {
      image = "redis";
      volumes = [ "wger_redis-data:/data:rw" ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=redis-cli ping"
        "--health-interval=10s"
        "--health-retries=5"
        "--health-start-period=30s"
        "--health-timeout=5s"
        "--network-alias=cache"
        "--network=wger_network"
      ];
    };
    systemd.services."podman-wger-cache" = {
      serviceConfig = { Restart = lib.mkOverride 90 "always"; };
      after = [
        "podman-network-wger_network.service"
        "podman-volume-wger_redis-data.service"
      ];
      requires = [
        "podman-network-wger_network.service"
        "podman-volume-wger_redis-data.service"
      ];
      partOf = [ "podman-compose-wger-root.target" ];
      wantedBy = [ "podman-compose-wger-root.target" ];
    };
    virtualisation.oci-containers.containers."wger-celery_beat" = {
      image = "wger/server:latest";
      environment = {
        "ACCESS_TOKEN_LIFETIME" = "10";
        "ALLOW_GUEST_USERS" = "True";
        "ALLOW_REGISTRATION" = "True";
        "ALLOW_UPLOAD_VIDEOS" = "True";
        "AXES_COOLOFF_TIME" = "30";
        "AXES_ENABLED" = "True";
        "AXES_FAILURE_LIMIT" = "10";
        "AXES_HANDLER" = "axes.handlers.cache.AxesCacheHandler";
        "AXES_IPWARE_META_PRECEDENCE_ORDER" =
          "HTTP_X_FORWARDED_FOR,REMOTE_ADDR";
        "AXES_IPWARE_PROXY_COUNT" = "1";
        "AXES_LOCKOUT_PARAMETERS" = "ip_address";
        "CELERY_BACKEND" = "redis://cache:6379/2";
        "CELERY_BROKER" = "redis://cache:6379/2";
        "CELERY_FLOWER_PASSWORD" = "adminadmin";
        "DJANGO_CACHE_BACKEND" = "django_redis.cache.RedisCache";
        "DJANGO_CACHE_CLIENT_CLASS" = "django_redis.client.DefaultClient";
        "DJANGO_CACHE_LOCATION" = "redis://cache:6379/1";
        "DJANGO_CACHE_TIMEOUT" = "1296000";
        "DJANGO_CLEAR_STATIC_FIRST" = "False";
        "DJANGO_DB_DATABASE" = "wger";
        "DJANGO_DB_ENGINE" = "django.db.backends.postgresql";
        "DJANGO_DB_HOST" = "db";
        "DJANGO_DB_PASSWORD" = "wger";
        "DJANGO_DB_PORT" = "5432";
        "DJANGO_DB_USER" = "wger";
        "DJANGO_DEBUG" = "False";
        "DJANGO_PERFORM_MIGRATIONS" = "True";
        "DOWNLOAD_INGREDIENTS_FROM" = "WGER";
        "EXERCISE_CACHE_TTL" = "18000";
        "FROM_EMAIL" = "wger Workout Manager <wger@example.com>";
        "MIN_ACCOUNT_AGE_TO_TRUST" = "21";
        "NUMBER_OF_PROXIES" = "1";
        "REFRESH_TOKEN_LIFETIME" = "24";
        "SECRET_KEY" = "wger-docker-supersecret-key-1234567890!@#$%^&*(-_)";
        "SIGNING_KEY" = "wger-docker-secret-jwtkey-1234567890!@#$%^&*(-_=+)";
        "SITE_URL" = "http://localhost";
        "SYNC_EXERCISES_CELERY" = "True";
        "SYNC_EXERCISE_IMAGES_CELERY" = "True";
        "SYNC_EXERCISE_VIDEOS_CELERY" = "True";
        "SYNC_INGREDIENTS_CELERY" = "True";
        "TIME_ZONE" = "Europe/Berlin";
        "USE_CELERY" = "True";
        "USE_RECAPTCHA" = "False";
        "WGER_INSTANCE" = "https://wger.de";
        "WGER_USE_GUNICORN" = "True";
      };
      volumes = [ "wger_celery-beat:/home/wger/beat:rw" ];
      cmd = [ "/start-beat" ];
      dependsOn = [ "wger-celery_worker" ];
      log-driver = "journald";
      extraOptions = [ "--network-alias=celery_beat" "--network=wger_network" ];
    };
    systemd.services."podman-wger-celery_beat" = {
      serviceConfig = { Restart = lib.mkOverride 90 "no"; };
      after = [
        "podman-network-wger_network.service"
        "podman-volume-wger_celery-beat.service"
      ];
      requires = [
        "podman-network-wger_network.service"
        "podman-volume-wger_celery-beat.service"
      ];
      partOf = [ "podman-compose-wger-root.target" ];
      wantedBy = [ "podman-compose-wger-root.target" ];
    };
    virtualisation.oci-containers.containers."wger-celery_worker" = {
      image = "wger/server:latest";
      environment = {
        "ACCESS_TOKEN_LIFETIME" = "10";
        "ALLOW_GUEST_USERS" = "True";
        "ALLOW_REGISTRATION" = "True";
        "ALLOW_UPLOAD_VIDEOS" = "True";
        "AXES_COOLOFF_TIME" = "30";
        "AXES_ENABLED" = "True";
        "AXES_FAILURE_LIMIT" = "10";
        "AXES_HANDLER" = "axes.handlers.cache.AxesCacheHandler";
        "AXES_IPWARE_META_PRECEDENCE_ORDER" =
          "HTTP_X_FORWARDED_FOR,REMOTE_ADDR";
        "AXES_IPWARE_PROXY_COUNT" = "1";
        "AXES_LOCKOUT_PARAMETERS" = "ip_address";
        "CELERY_BACKEND" = "redis://cache:6379/2";
        "CELERY_BROKER" = "redis://cache:6379/2";
        "CELERY_FLOWER_PASSWORD" = "adminadmin";
        "DJANGO_CACHE_BACKEND" = "django_redis.cache.RedisCache";
        "DJANGO_CACHE_CLIENT_CLASS" = "django_redis.client.DefaultClient";
        "DJANGO_CACHE_LOCATION" = "redis://cache:6379/1";
        "DJANGO_CACHE_TIMEOUT" = "1296000";
        "DJANGO_CLEAR_STATIC_FIRST" = "False";
        "DJANGO_DB_DATABASE" = "wger";
        "DJANGO_DB_ENGINE" = "django.db.backends.postgresql";
        "DJANGO_DB_HOST" = "db";
        "DJANGO_DB_PASSWORD" = "wger";
        "DJANGO_DB_PORT" = "5432";
        "DJANGO_DB_USER" = "wger";
        "DJANGO_DEBUG" = "False";
        "DJANGO_PERFORM_MIGRATIONS" = "True";
        "DOWNLOAD_INGREDIENTS_FROM" = "WGER";
        "EXERCISE_CACHE_TTL" = "18000";
        "FROM_EMAIL" = "wger Workout Manager <wger@example.com>";
        "MIN_ACCOUNT_AGE_TO_TRUST" = "21";
        "NUMBER_OF_PROXIES" = "1";
        "REFRESH_TOKEN_LIFETIME" = "24";
        "SECRET_KEY" = "wger-docker-supersecret-key-1234567890!@#$%^&*(-_)";
        "SIGNING_KEY" = "wger-docker-secret-jwtkey-1234567890!@#$%^&*(-_=+)";
        "SITE_URL" = "http://localhost";
        "SYNC_EXERCISES_CELERY" = "True";
        "SYNC_EXERCISE_IMAGES_CELERY" = "True";
        "SYNC_EXERCISE_VIDEOS_CELERY" = "True";
        "SYNC_INGREDIENTS_CELERY" = "True";
        "TIME_ZONE" = "Europe/Berlin";
        "USE_CELERY" = "True";
        "USE_RECAPTCHA" = "False";
        "WGER_INSTANCE" = "https://wger.de";
        "WGER_USE_GUNICORN" = "True";
      };
      volumes = [ "wger_media:/home/wger/media:rw" ];
      cmd = [ "/start-worker" ];
      dependsOn = [ "wger-web" ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=celery -A wger inspect ping"
        "--health-interval=10s"
        "--health-retries=5"
        "--health-start-period=30s"
        "--health-timeout=5s"
        "--network-alias=celery_worker"
        "--network=wger_network"
      ];
    };
    systemd.services."podman-wger-celery_worker" = {
      serviceConfig = { Restart = lib.mkOverride 90 "no"; };
      after = [
        "podman-network-wger_network.service"
        "podman-volume-wger_media.service"
      ];
      requires = [
        "podman-network-wger_network.service"
        "podman-volume-wger_media.service"
      ];
      partOf = [ "podman-compose-wger-root.target" ];
      wantedBy = [ "podman-compose-wger-root.target" ];
    };
    virtualisation.oci-containers.containers."wger-db" = {
      image = "postgres:15-alpine";
      environment = {
        "POSTGRES_DB" = "wger";
        "POSTGRES_PASSWORD" = "wger";
        "POSTGRES_USER" = "wger";
      };
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=pg_isready -U wger"
        "--health-interval=10s"
        "--health-retries=5"
        "--health-start-period=30s"
        "--health-timeout=5s"
        "--network-alias=db"
        "--network=wger_network"
      ];
    };
    systemd.services."podman-wger-db" = {
      serviceConfig = { Restart = lib.mkOverride 90 "always"; };
      after = [ "podman-network-wger_network.service" ];
      requires = [ "podman-network-wger_network.service" ];
      partOf = [ "podman-compose-wger-root.target" ];
      wantedBy = [ "podman-compose-wger-root.target" ];
    };
    virtualisation.oci-containers.containers."wger-nginx" = {
      image = "nginx:stable";
      volumes = [
        "/home/omega/ws/services/wger/config/nginx.conf:/etc/nginx/conf.d/default.conf:rw"
        "wger_media:/wger/media:ro"
        "wger_static:/wger/static:ro"
      ];
      ports = [ "80:80/tcp" ];
      dependsOn = [ "wger-web" ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=service nginx status"
        "--health-interval=10s"
        "--health-retries=5"
        "--health-start-period=30s"
        "--health-timeout=5s"
        "--network-alias=nginx"
        "--network=wger_network"
      ];
    };
    systemd.services."podman-wger-nginx" = {
      serviceConfig = { Restart = lib.mkOverride 90 "always"; };
      after = [
        "podman-network-wger_network.service"
        "podman-volume-wger_media.service"
        "podman-volume-wger_static.service"
      ];
      requires = [
        "podman-network-wger_network.service"
        "podman-volume-wger_media.service"
        "podman-volume-wger_static.service"
      ];
      partOf = [ "podman-compose-wger-root.target" ];
      wantedBy = [ "podman-compose-wger-root.target" ];
    };
    virtualisation.oci-containers.containers."wger-web" = {
      image = "wger/server:latest";
      environment = {
        "ACCESS_TOKEN_LIFETIME" = "10";
        "ALLOW_GUEST_USERS" = "True";
        "ALLOW_REGISTRATION" = "True";
        "ALLOW_UPLOAD_VIDEOS" = "True";
        "AXES_COOLOFF_TIME" = "30";
        "AXES_ENABLED" = "True";
        "AXES_FAILURE_LIMIT" = "10";
        "AXES_HANDLER" = "axes.handlers.cache.AxesCacheHandler";
        "AXES_IPWARE_META_PRECEDENCE_ORDER" =
          "HTTP_X_FORWARDED_FOR,REMOTE_ADDR";
        "AXES_IPWARE_PROXY_COUNT" = "1";
        "AXES_LOCKOUT_PARAMETERS" = "ip_address";
        "CELERY_BACKEND" = "redis://cache:6379/2";
        "CELERY_BROKER" = "redis://cache:6379/2";
        "CELERY_FLOWER_PASSWORD" = "adminadmin";
        "DJANGO_CACHE_BACKEND" = "django_redis.cache.RedisCache";
        "DJANGO_CACHE_CLIENT_CLASS" = "django_redis.client.DefaultClient";
        "DJANGO_CACHE_LOCATION" = "redis://cache:6379/1";
        "DJANGO_CACHE_TIMEOUT" = "1296000";
        "DJANGO_CLEAR_STATIC_FIRST" = "False";
        "DJANGO_DB_DATABASE" = "wger";
        "DJANGO_DB_ENGINE" = "django.db.backends.postgresql";
        "DJANGO_DB_HOST" = "db";
        "DJANGO_DB_PASSWORD" = "wger";
        "DJANGO_DB_PORT" = "5432";
        "DJANGO_DB_USER" = "wger";
        "DJANGO_DEBUG" = "False";
        "DJANGO_PERFORM_MIGRATIONS" = "True";
        "DOWNLOAD_INGREDIENTS_FROM" = "WGER";
        "EXERCISE_CACHE_TTL" = "18000";
        "FROM_EMAIL" = "wger Workout Manager <wger@example.com>";
        "MIN_ACCOUNT_AGE_TO_TRUST" = "21";
        "NUMBER_OF_PROXIES" = "1";
        "REFRESH_TOKEN_LIFETIME" = "24";
        "SECRET_KEY" = "wger-docker-supersecret-key-1234567890!@#$%^&*(-_)";
        "SIGNING_KEY" = "wger-docker-secret-jwtkey-1234567890!@#$%^&*(-_=+)";
        "SITE_URL" = "http://localhost";
        "SYNC_EXERCISES_CELERY" = "True";
        "SYNC_EXERCISE_IMAGES_CELERY" = "True";
        "SYNC_EXERCISE_VIDEOS_CELERY" = "True";
        "SYNC_INGREDIENTS_CELERY" = "True";
        "TIME_ZONE" = "Europe/Berlin";
        "USE_CELERY" = "True";
        "USE_RECAPTCHA" = "False";
        "WGER_INSTANCE" = "https://wger.de";
        "WGER_USE_GUNICORN" = "True";
      };
      volumes = [ "wger_static:/home/wger/static:rw" ];
      dependsOn = [ "wger-cache" "wger-db" ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=wget --no-verbose --tries=1 --spider http://localhost:8000"
        "--health-interval=10s"
        "--health-retries=5"
        "--health-start-period=5m0s"
        "--health-timeout=5s"
        "--network-alias=web"
        "--network=wger_network"
      ];
    };
    systemd.services."podman-wger-web" = {
      serviceConfig = { Restart = lib.mkOverride 90 "always"; };
      after = [
        "podman-network-wger_network.service"
        "podman-volume-wger_static.service"
      ];
      requires = [
        "podman-network-wger_network.service"
        "podman-volume-wger_static.service"
      ];
      partOf = [ "podman-compose-wger-root.target" ];
      wantedBy = [ "podman-compose-wger-root.target" ];
    };

    # Networks
    systemd.services."podman-network-wger_network" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "podman network rm -f wger_network";
      };
      script = ''
        podman network inspect wger_network || podman network create wger_network
      '';
      partOf = [ "podman-compose-wger-root.target" ];
      wantedBy = [ "podman-compose-wger-root.target" ];
    };

    # Volumes
    systemd.services."podman-volume-wger_celery-beat" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        podman volume inspect wger_celery-beat || podman volume create wger_celery-beat
      '';
      partOf = [ "podman-compose-wger-root.target" ];
      wantedBy = [ "podman-compose-wger-root.target" ];
    };
    systemd.services."podman-volume-wger_media" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        podman volume inspect wger_media || podman volume create wger_media
      '';
      partOf = [ "podman-compose-wger-root.target" ];
      wantedBy = [ "podman-compose-wger-root.target" ];
    };
    systemd.services."podman-volume-wger_redis-data" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        podman volume inspect wger_redis-data || podman volume create wger_redis-data
      '';
      partOf = [ "podman-compose-wger-root.target" ];
      wantedBy = [ "podman-compose-wger-root.target" ];
    };
    systemd.services."podman-volume-wger_static" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        podman volume inspect wger_static || podman volume create wger_static
      '';
      partOf = [ "podman-compose-wger-root.target" ];
      wantedBy = [ "podman-compose-wger-root.target" ];
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."podman-compose-wger-root" = {
      unitConfig = { Description = "Root target generated by compose2nix."; };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
