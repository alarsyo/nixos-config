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

        listen = [
          # FIXME: hardcoded tailscale IP
          {
            addr = "100.115.172.44";
            port = 443;
            ssl = true;
          }
          {
            addr = "100.115.172.44";
            port = 80;
            ssl = false;
          }
        ];

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
        };

        extraConfig = ''
          proxy_connect_timeout 600;
          proxy_read_timeout 600;
          proxy_send_timeout 600;
        '';
      };
    };

    security.acme.certs.${fqdn}.extraDomainNames = ["photoprism.${domain}"];

    my.services.restic-backup = mkIf cfg.enable {
      paths = [
        cfg.home
      ];
    };
  };
}
