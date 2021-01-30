{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.my.services.miniflux;

  domain = config.networking.domain;
in {
  options.my.services.miniflux = {
    enable = mkEnableOption "Serve a Miniflux instance";

    adminCredentialsFile = mkOption {
      type = types.str;
      default = null;
      example = "./secrets/miniflux-admin-credentials";
      description = "File containing ADMIN_USERNAME= and ADMIN_PASSWORD=";
    };

    privatePort = mkOption {
      type = types.int;
      default = 8080;
      example = 8080;
      description = "Port to serve the app";
    };
  };

  config = mkIf cfg.enable {
    # services.postgresql is automatically enabled by services.miniflux, let's
    # back it up
    services.postgresqlBackup = {
      databases = [ "miniflux" ];
    };

    services.miniflux = {
      enable = true;
      adminCredentialsFile = cfg.adminCredentialsFile;
      # TODO: setup metrics collection
      config = {
        LISTEN_ADDR = "127.0.0.1:${toString cfg.privatePort}";
        BASE_URL = "https://reader.${domain}/";
      };
    };

    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;

      virtualHosts = {
        "reader.${domain}" = {
          forceSSL = true;
          enableACME = true;

          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.privatePort}";
          };
        };
      };
    };
  };
}
