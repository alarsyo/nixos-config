{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.my.services.gitea;
  my = config.my;

  domain = config.networking.domain;
in {
  options.my.services.gitea = {
    enable = mkEnableOption "Personal Git hosting with Gitea";

    privatePort = mkOption {
      type = types.int;
      default = 8082;
      example = 8082;
      description = "Port to serve the app";
    };
  };

  config = mkIf cfg.enable {
    # use git as user to have `git clone git@git.domain`
    users.users.git = {
      description = "Gitea Service";
      home = config.services.gitea.stateDir;
      useDefaultShell = true;
      group = "git";

      # the systemd service for the gitea module seems to hardcode the group as
      # gitea, so, uh, just in case?
      extraGroups = [ "gitea" ];

      isSystemUser = true;
    };
    users.groups.git = { };

    services.gitea = {
      enable = true;
      user = "git";
      domain = "git.${domain}";
      appName = "Personal Forge";
      rootUrl = "https://git.${domain}/";
      httpAddress = "127.0.0.1";
      httpPort = cfg.privatePort;
      log.level = "Info"; # [ "Trace" "Debug" "Info" "Warn" "Error" "Critical" ]
      lfs.enable = true;

      # NOTE: temporarily remove this for initial setup
      disableRegistration = true;

      # only send cookies via HTTPS
      cookieSecure = true;

      settings = {
        other.SHOW_FOOTER_VERSION = false;
      };

      dump.enable = true;

      database = {
        type = "postgres";
        # user needs to be the same as gitea user
        user = "git";
      };
    };

    my.services.borg-backup = mkIf cfg.enable {
      paths = [ config.services.gitea.dump.backupDir ];
    };

    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;

      virtualHosts = {
        "git.${domain}" = {
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
