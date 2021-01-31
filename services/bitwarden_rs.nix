{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.my.services.bitwarden_rs;
  my = config.my;

  domain = config.networking.domain;
in {
  options.my.services.bitwarden_rs = {
    enable = mkEnableOption "Bitwarden";

    privatePort = mkOption {
      type = types.int;
      default = 8081;
      example = 8081;
      description = "Port used internally for rocket server";
    };

    websocketPort = mkOption {
      type = types.int;
      default = 3012;
      example = 3012;
      description = "Port used for websocket connections";
    };
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;

      initialScript = pkgs.writeText "bitwarden_rs-init.sql" ''
          CREATE ROLE "bitwarden_rs" WITH LOGIN;
          CREATE DATABASE "bitwarden_rs" WITH OWNER "bitwarden_rs";
        '';
    };

    services.postgresqlBackup = mkIf my.services.postgresql-backup.enable {
      databases = [ "bitwarden_rs" ];
    };

    services.bitwarden_rs = {
      enable = true;
      dbBackend = "postgresql";
      config = {
        TZ = "Europe/Paris";
        WEB_VAULT_ENABLED = true;
        WEBSOCKET_ENABLED = true;
        WEBSOCKET_PORT = cfg.websocketPort;
        ROCKET_PORT = cfg.privatePort;
        SIGNUPS_ALLOWED = false;
        INVITATIONS_ALLOWED = false;
        DOMAIN = "https://pass.${domain}";
        DATABASE_URL = "postgresql://bitwarden_rs@/bitwarden_rs";
      };
    };

    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;

      virtualHosts = {
        "pass.${domain}" = {
          forceSSL = true;
          enableACME = true;

          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.privatePort}";
            proxyWebsockets = true;
          };
          locations."/notifications/hub" = {
            proxyPass = "http://127.0.0.1:${toString cfg.websocketPort}";
            proxyWebsockets = true;
          };
          locations."/notifications/hub/negotiate" = {
            proxyPass = "http://127.0.0.1:${toString cfg.privatePort}";
            proxyWebsockets = true;
          };
        };
      };
    };

    systemd.services.matrix-synapse = {
      after = [ "postgresql.service" ];
    };

    # needed for bitwarden to find files to serve for the vault
    environment.systemPackages = with pkgs; [
      bitwarden_rs-vault
    ];

    my.services.borg-backup = mkIf cfg.enable {
      paths = [ "/var/lib/bitwarden_rs" ];
      exclude = [ "/var/lib/bitwarden_rs/icon_cache" ];
    };
  };

}
