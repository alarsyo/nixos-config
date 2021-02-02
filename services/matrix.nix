# Matrix homeserver setup, using different endpoints for federation and client
# traffic. The main trick for this is defining two nginx servers endpoints for
# matrix.domain.com, each listening on different ports.
#
# Configuration inspired by :
#
# - https://github.com/delroth/infra.delroth.net/blob/master/roles/matrix-synapse.nix
# - https://nixos.org/manual/nixos/stable/index.html#module-services-matrix
#
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.my.services.matrix;
  my = config.my;

  federationPort = { public = 8448; private = 11338; };
  clientPort = { public = 443; private = 11339; };
  domain = config.networking.domain;
in {
  options.my.services.matrix = {
    enable = lib.mkEnableOption "Matrix Synapse";

    registration_shared_secret = lib.mkOption {
      type = types.str;
      default = null;
      example = "deadbeef";
      description = "Shared secret to register users";
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_12;
    };

    services.postgresqlBackup = mkIf my.services.postgresql-backup.enable {
      databases = [ "matrix-synapse" ];
    };

    services.matrix-synapse = {
      enable = true;
      server_name = domain;
      public_baseurl = "https://matrix.${domain}";

      registration_shared_secret = cfg.registration_shared_secret;

      listeners = [
        # Federation
        {
          bind_address = "::1";
          port = federationPort.private;
          tls = false;  # Terminated by nginx.
          x_forwarded = true;
          resources = [ { names = [ "federation" ]; compress = false; } ];
        }

        # Client
        {
          bind_address = "::1";
          port = clientPort.private;
          tls = false;  # Terminated by nginx.
          x_forwarded = true;
          resources = [ { names = [ "client" ]; compress = false; } ];
        }
      ];
    };

    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;

      virtualHosts = {
        "matrix.${domain}" = {
          forceSSL = true;
          enableACME = true;

          locations =
            let
              proxyToClientPort = {
                proxyPass = "http://[::1]:${toString clientPort.private}";
              };
            in {
              # Or do a redirect instead of the 404, or whatever is appropriate
              # for you. But do not put a Matrix Web client here! See the
              # Element web section below.
              "/".return = "404";

              "/_matrix" = proxyToClientPort;
              "/_synapse/client" = proxyToClientPort;
            };

          listen = [
            { addr = "0.0.0.0"; port = clientPort.public; ssl = true; }
            { addr = "[::]"; port = clientPort.public; ssl = true; }
          ];

        };

        # same as above, but listening on the federation port
        "matrix.${domain}_federation" = rec {
          forceSSL = true;
          serverName = "matrix.${domain}";
          useACMEHost = serverName;

          locations."/".return = "404";

          locations."/_matrix" = {
            proxyPass = "http://[::1]:${toString federationPort.private}";
          };

          listen = [
            { addr = "0.0.0.0"; port = federationPort.public; ssl = true; }
            { addr = "[::]"; port = federationPort.public; ssl = true; }
          ];

        };

        "${domain}" = {
          forceSSL = true;
          enableACME = true;

          locations."= /.well-known/matrix/server".extraConfig =
            let
              server = { "m.server" = "matrix.${domain}:${toString federationPort.public}"; };
            in ''
            add_header Content-Type application/json;
            return 200 '${builtins.toJSON server}';
          '';

          locations."= /.well-known/matrix/client".extraConfig =
            let
              client = {
                "m.homeserver" =  { "base_url" = "https://matrix.${domain}"; };
                "m.identity_server" =  { "base_url" = "https://vector.im"; };
              };
              # ACAO required to allow element-web on any URL to request this json file
            in ''
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '${builtins.toJSON client}';
          '';
        };

        # Element Web app deployment
        #
        "chat.${domain}" = {
          enableACME = true;
          forceSSL = true;

          root = pkgs.element-web.override {
            conf = {
              default_server_config = {
                "m.homeserver" = {
                  "base_url" = "https://matrix.${domain}";
                  "server_name" = "${domain}";
                };
                "m.identity_server" = {
                  "base_url" = "https://vector.im";
                };
              };
              showLabsSettings = true;
              defaultCountryCode = "FR"; # cocorico
              roomDirectory = {
                "servers" = [
                  "matrix.org"
                  "mozilla.org"
                  "prologin.org"
                ];
              };
            };
          };
        };
      };
    };

    # For administration tools.
    environment.systemPackages = [ pkgs.matrix-synapse ];

    networking.firewall.allowedTCPPorts = [
      clientPort.public
      federationPort.public
    ];

    my.services.borg-backup = mkIf cfg.enable {
      paths = [ "/var/lib/matrix-synapse" ];
    };
  };
}
