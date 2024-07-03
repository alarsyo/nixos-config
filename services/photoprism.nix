{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    ;

  cfg = config.my.services.photoprism;
  my = config.my;

  domain = config.networking.domain;
  hostname = config.networking.hostName;
  fqdn = "${hostname}.${domain}";
in {
  options.my.services.photoprism = let
    inherit (lib) types;
  in {
    enable = mkEnableOption "Photoprism config";

    home = mkOption {
      type = types.str;
      default = "/var/lib/photoprism";
      example = "/var/lib/photoprism";
      description = "Home for the photoprism service, where data will be stored";
    };

    port = mkOption {
      type = types.port;
      default = 2342;
      example = 8080;
      description = "Internal port for Photoprism webapp";
    };
  };

  config = mkIf cfg.enable {
    users.users.photoprism = {
      isSystemUser = true;
      home = cfg.home;
      createHome = true;
      group = "photoprism";
    };
    users.groups.photoprism = {};

    services.nginx.virtualHosts = {
      "photoprism.${domain}" = {
        forceSSL = true;
        useACMEHost = fqdn;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
        };

        extraConfig = ''
          proxy_connect_timeout 600;
          proxy_read_timeout 600;
          proxy_send_timeout 600;
          client_max_body_size 500m;
          access_log syslog:server=unix:/dev/log,tag=photoprism;
        '';
      };
    };

    security.acme.certs.${fqdn}.extraDomainNames = ["photoprism.${domain}"];

    my.services.restic-backup = mkIf cfg.enable {
      paths = [
        cfg.home
      ];
      exclude = [
        "${cfg.home}/storage"
      ];
    };

    services.fail2ban.jails = {
      photoprism = ''
        enabled = true
        filter = photoprism-failed-login
        port = http,https
        maxretry = 3
      '';
    };

    environment.etc = {
      "fail2ban/filter.d/photoprism-failed-login.conf".text = ''
        [Definition]
        failregex = ^.* photoprism: <HOST> - .*"POST \/api\/v1\/session HTTP[^"]*" 400 .*$
        ignoreregex =
        journalmatch = _SYSTEMD_UNIT=nginx.service _TRANSPORT=syslog
      '';
    };
  };
}
