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

  cfg = config.my.services.gitea;
  my = config.my;

  domain = config.networking.domain;
  hostname = config.networking.hostName;
  fqdn = "${hostname}.${domain}";

  giteaUser = "git";
in {
  options.my.services.gitea = let
    inherit (lib) types;
  in {
    enable = mkEnableOption "Personal Git hosting with Gitea";

    privatePort = mkOption {
      type = types.port;
      default = 8082;
      example = 8082;
      description = "Port to serve the app";
    };
  };

  config = mkIf cfg.enable {
    # use git as user to have `git clone git@git.domain`
    users.users.${giteaUser} = {
      description = "Gitea Service";
      home = config.services.gitea.stateDir;
      useDefaultShell = true;
      group = giteaUser;

      # the systemd service for the gitea module seems to hardcode the group as
      # gitea, so, uh, just in case?
      extraGroups = ["gitea"];

      isSystemUser = true;
    };
    users.groups.${giteaUser} = {};

    services.gitea = {
      enable = true;
      user = giteaUser;
      appName = "Personal Forge";
      lfs.enable = true;

      settings = {
        server = {
          ROOT_URL = "https://git.${domain}/";
          DOMAIN = "git.${domain}";
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = cfg.privatePort;
        };
        log.LEVEL = "Warn"; # [ "Trace" "Debug" "Info" "Warn" "Error" "Critical" ]
        other.SHOW_FOOTER_VERSION = false;
        repository = {
          ENABLE_PUSH_CREATE_USER = true;
          DEFAULT_BRANCH = "main";
        };

        # NOTE: temporarily remove this for initial setup
        service.DISABLE_REGISTRATION = true;

        # only send cookies via HTTPS
        session.COOKIE_SECURE = true;
      };

      # NixOS module uses `gitea dump` to backup repositories and the database,
      # but it produces a single .zip file that's not very restic friendly.
      # I configure my backup system manually below.
      dump.enable = false;

      database = {
        type = "postgres";
        # user needs to be the same as gitea user
        user = giteaUser;
        name = giteaUser;
      };
    };

    # FIXME: Borg *could* be backing up files while they're being edited by
    # gitea, so it may produce corrupt files in the snapshot if I push stuff
    # around midnight. I'm not sure how `gitea dump` handles this either,
    # though.
    my.services.restic-backup = {
      paths = [
        config.services.gitea.lfs.contentDir
        config.services.gitea.repositoryRoot
      ];
    };

    # NOTE: no need to use postgresql.ensureDatabases because the gitea module
    # takes care of this automatically
    services.postgresqlBackup = {
      databases = [config.services.gitea.database.name];
    };

    services.nginx = {
      virtualHosts = {
        "git.${domain}" = {
          forceSSL = true;
          useACMEHost = fqdn;

          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.privatePort}";
          };
        };
      };
    };

    security.acme.certs.${fqdn}.extraDomainNames = ["git.${domain}"];

    systemd.services.gitea.preStart = "${pkgs.coreutils}/bin/ln -sfT ${./templates} ${config.services.gitea.stateDir}/custom/templates";
  };
}
