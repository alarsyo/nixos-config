{ lib, config, pkgs, ... }:

# TODO: setup prometheus exporter

let
  cfg = config.my.services.nextcloud;
  my = config.my;
  domain = config.networking.domain;
  dbName = "nextcloud";
in
{
  options.my.services.nextcloud = {
    enable = lib.mkEnableOption "NextCloud";
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;

      ensureDatabases = [ dbName ];
      ensureUsers = [
        {
          name = "nextcloud";
          ensurePermissions = {
            "DATABASE ${dbName}" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    services.postgresqlBackup = {
      databases = [ dbName ];
    };

    services.nextcloud = {
      enable = true;

      hostName = "cloud.${domain}";
      https = true;
      package = pkgs.nextcloud21;

      maxUploadSize = "1G";

      config = {
        overwriteProtocol = "https";

        defaultPhoneRegion = "FR";

        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbname = dbName;
        dbhost = "/run/postgresql";

        adminuser = my.secrets.nextcloud-admin-user;
        adminpass = my.secrets.nextcloud-admin-pass;
      };
    };

    services.nginx = {
      virtualHosts = {
        "cloud.${domain}" = {
          forceSSL = true;
          enableACME = true;
        };
      };
    };

    my.services.borg-backup = lib.mkIf cfg.enable {
      paths = [ config.services.nextcloud.home ];
    };
  };
}
